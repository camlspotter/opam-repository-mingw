module U = Unix

type pipe_state =
  | Open
  | Closed
  | Uninit

type pipe_with_status =
  {
    mutable state: pipe_state;
    mutable fd: U.file_descr
  }


let win = match Sys.os_type.[0] with
| 'W' -> true
| _ -> false

let null_device = if win then "NUL" else "/dev/null"

let try_finalize f x final y =
  let res =
    try
      f x
    with
    | exn ->
      let () = final y in
      raise exn
  in
  final y;
  res


let pipe a b =
  let tmp1,tmp2 = U.pipe () in
  a.state <- Open;
  a.fd <- tmp1;
  b.state <- Open;
  b.fd <- tmp2

let new_pipe () =
  {state = Uninit;
   fd = U.stderr}

let rec eintr1 f a =
  try
    f a
  with
  | U.Unix_error(U.EINTR,_,_) ->  eintr1 f a

let rec eintr2 f a b =
  try
    f a b
  with
  | U.Unix_error(U.EINTR,_,_) -> eintr2 f a b

let rec eintr3 f a b c =
  try
    f a b c
  with
  | U.Unix_error(U.EINTR,_,_) -> eintr3 f a b c


let rec eintr4 f a b c d=
  try
    f a b c d
  with
  | U.Unix_error(U.EINTR,_,_) -> eintr4 f a b c d

let rec eintr6 f a b c d e g =
  try
    f a b c d e g
  with
  | U.Unix_error(U.EINTR,_,_) ->
    eintr6 f a b c d e g


let close_pipe a =
  match a.state with
  | Closed
  | Uninit -> ()
  | Open ->
    a.state <- Closed ;
    eintr1 U.close a.fd

type io_out = [
  | `Fd of U.file_descr
  | `Null
  | `Stdout
  | `Stderr
  | `Buffer of Buffer.t
  | `Fun of (string -> unit)]

type io_in =
  [`String of string
  |`Null
  |`Fd of U.file_descr
  (* |`Fun of (out_channel -> unit) (* not usable yet *) *)
  ]

let close_pipe_ne a = try close_pipe a with |_ -> ()

let str_buffer_len = 8192 (* 32768 *)


let run ?(env=U.environment ()) ?(stdin=`Null) ?(stderr=`Stderr) ?(stdout=`Stdout) prog args : int =
  let tmp_str = Bytes.create str_buffer_len
  and p_stdout_read = new_pipe ()
  and p_stdout_write = new_pipe ()
  and p_stderr_read = new_pipe ()
  and p_stderr_write = new_pipe ()
  and p_stdin_read = new_pipe ()
  and p_stdin_write = new_pipe ()
  and args = Array.of_list (prog::args)
  in
  try_finalize ( fun () ->
      let () =
        let comm p fd =
          let fd = eintr1 U.dup fd in
          p.fd <-  fd;
          p.state <- Open
        in

        begin match stdout with
        | `Stdout -> p_stdout_write.fd <- U.stdout
        | `Stderr -> p_stdout_write.fd <- U.stderr
        | `Null ->
          let fd = eintr3 U.openfile null_device [ U.O_WRONLY ] 0o600 in
          p_stdout_write.fd <- fd;
          p_stdout_write.state <- Open
        | `Fd fd ->
          p_stdout_write.fd <- fd
        | _ -> pipe p_stdout_read p_stdout_write
        end;

        begin match stderr with
        | `Stdout -> p_stderr_write.fd <- U.stdout
        | `Stderr -> p_stderr_write.fd <- U.stderr
        | `Null ->
          let fd = eintr3 U.openfile null_device [ U.O_WRONLY ] 0o600 in
          p_stderr_write.fd <- fd;
          p_stderr_write.state <- Open
        | `Fd fd ->
          p_stderr_write.fd <- fd;
        | _ -> pipe p_stderr_read p_stderr_write;
        end;

        begin match stdin with
        | `Null ->
          let fd = eintr3 U.openfile null_device [ U.O_RDONLY ] 0o400 in
          p_stdin_read.fd <- fd;
          p_stdin_read.state <- Open
        | `Fd fd ->
          comm p_stdin_read fd;
        | _ -> pipe p_stdin_read  p_stdin_write;
        end;
      in

      if p_stdin_write.state = Open then
        U.set_close_on_exec p_stdin_write.fd;

      if p_stdout_read.state = Open then
        U.set_close_on_exec p_stdout_read.fd;

      if p_stderr_read.state = Open then
        U.set_close_on_exec p_stderr_read.fd;

      let pid = eintr6 U.create_process_env prog args env p_stdin_read.fd p_stdout_write.fd p_stderr_write.fd in

      close_pipe p_stdout_write;
      close_pipe p_stdin_read;
      close_pipe p_stderr_write;

      let f_read r =
        let is_stdout =
          if r = p_stderr_read.fd then
            false
          else (
            assert ( r = p_stdout_read.fd );
            true
          )
        in
        let x = try eintr4 U.read r tmp_str 0 str_buffer_len with | _ -> -1 in
        if x <= 0 then (
          if is_stdout then
            close_pipe p_stdout_read
          else
            close_pipe p_stderr_read
        )
        else (
          match if is_stdout then stdout else stderr with
          | `Fd _
          | `Null
          | `Stdout
          | `Stderr -> ()
          | `Buffer b -> Buffer.add_subbytes b tmp_str 0 x
          | `Fun (f: string -> unit) -> f (Bytes.sub_string tmp_str 0 x)
        )
      in
      let to_write = match stdin with
      (*| `Fun f ->
        f (Unix.out_channel_of_descr p_stdin_write.fd);
        close_pipe p_stdin_write;
        ref "" *)
      | `Fd _
      | `String ""
      | `Null -> close_pipe p_stdin_write; ref ""
      | `String str -> ref str
      in
      while p_stdout_read.state = Open || p_stderr_read.state = Open || p_stdin_write.state = Open do
        let wl = if p_stdin_write.state = Open then [p_stdin_write.fd] else [] in
        let rl = if p_stderr_read.state = Open then [p_stderr_read.fd] else [] in
        let rl = if p_stdout_read.state = Open then p_stdout_read.fd :: rl else rl in
        let r,w,_ = eintr4 U.select rl wl [] 3. in
        List.iter f_read r ;
        match w with
        | [] -> ()
        | [fd] ->
          assert (p_stdin_write.fd = fd);
          let str_len = String.length !to_write in
          assert (str_len > 0 );
          let n_written = eintr4 U.write_substring fd !to_write 0 str_len in
          if n_written >= str_len then (
            to_write := "";
            close_pipe p_stdin_write
          )
          else
            to_write := String.sub !to_write n_written (str_len - n_written)
        | _ -> assert false
      done;
      close_pipe p_stdout_read;
      close_pipe p_stderr_read;

      let _, process_status = eintr2 U.waitpid [] pid in
      let ret_code = match process_status with
      | U.WEXITED n -> n
      | U.WSIGNALED _ -> 2 (* like OCaml's uncaught exceptions *)
      | U.WSTOPPED _ ->
        (* only possible if the call was done using WUNTRACED
           or when the child is being traced *)
        3
      in
      ret_code
    ) () ( fun () ->
      close_pipe_ne p_stdin_read;
      close_pipe_ne p_stdin_write;
      close_pipe_ne p_stdout_read;
      close_pipe_ne p_stdout_write;
      close_pipe_ne p_stderr_write;
      close_pipe_ne p_stderr_read
    ) ()
