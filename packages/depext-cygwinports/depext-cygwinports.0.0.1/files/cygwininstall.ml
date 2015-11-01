exception Error of string

let re_newline = Re_pcre.re "([\r]*[\n])+" |> Re.compile
let (//) = Filename.concat

type mingw_arch =
  | Mingw32
  | Mingw64

let rex_mingw32 =
  Re_pcre.re "^mingw64-i686-([^\\s]+)[\\s]+([^\\s]+)[\\s]*$" |> Re.compile

let rex_mingw64 =
  Re_pcre.re "^mingw64-x86_64-([^\\s]+)[\\s]+([^\\s]+)[\\s]*$" |> Re.compile

let get_packages arch =
  let buf = Buffer.create 8192
  and ebuf = Buffer.create 10 in
  let ec =
    Run.run ~stderr:(`Buffer ebuf) ~stdout:(`Buffer buf) "cygcheck.exe" ["-cd"]
  in
  if ec <> 0 then
    raise (Error (Buffer.contents ebuf));
  let rex = match arch with
  | Mingw32 -> rex_mingw32
  | Mingw64 -> rex_mingw64 in
  let f htl el =
    (match Re_pcre.extract ~rex el with
    | [| _ ; a ; b |] -> Hashtbl.replace htl a b
    | exception Not_found -> ()
    | _ -> ());
    htl
  in
  Re_pcre.split ~rex:re_newline (Buffer.contents buf) |>
  List.fold_left f (Hashtbl.create 300)

type config = {
  cygwin_root: string;
  cygwin_arch: string;
  mingw_arch: string;
  mirror_cygports: string;
  mirror_cygwin: string;
} [@@deriving yojson]

let slash_rex = Re_perl.compile_pat "/"
let winpath s =
  Re.replace_string slash_rex ~by:"\\" s

let bin_dir = Filename.dirname Sys.executable_name
let etc_dir = (Filename.dirname bin_dir) // "etc"

let get_cywin_args config =
  let key = Filename.concat etc_dir "ports.gpg" in
  [ "-K" ; winpath key ; "-W"; "-B" ; "-R" ; winpath config.cygwin_root ;
    "-l" ; winpath (config.cygwin_root // "packages") ;
    "-n" ; "-s" ; config.mirror_cygports ;
    "-s" ; config.mirror_cygwin ]

let gui config =
  let cygwin_setup = bin_dir // "cygwin-dl.exe" in
  let args = cygwin_setup::(get_cywin_args config) in
  let run = config.cygwin_root // "bin" // "run.exe" in
  let ec = Run.run run args in
  exit (ec)

let install config arch ipkgs =
  let f () =
    let pkgs_now = get_packages arch in
    fun e -> if Hashtbl.mem pkgs_now e then false else true
  in
  match List.filter (f ()) ipkgs with
  | [] -> ()
  | ipkgs ->
    let cygwin_setup = bin_dir // "cygwin-dl.exe" in
    let str_pkgs =
      let pr = match arch with
      | Mingw64 -> "mingw64-x86_64-"
      | Mingw32 -> "mingw64-i686-" in
      List.map ( fun x -> pr ^ x ) ipkgs |> String.concat ","
    in
    let args = "-P" :: str_pkgs :: "-q" :: (get_cywin_args config) in
    let ec = Run.run cygwin_setup args in
    match List.filter (f ()) ipkgs with
    | [] -> ()
    | _ ->
      let msg =
        if ec <> 0 then
          Printf.sprintf "cygwin setup exit code:%d\n" ec
        else
          "installation failed"
      in
      raise (Error msg)

let print_list arch =
  let buf = Buffer.create 128 in
  let f a b =
    Buffer.add_string buf a;
    Buffer.add_char buf ':';
    for _i = String.length a to 50 do
      Buffer.add_char buf ' ';
    done;
    Buffer.add_string buf b;
    Buffer.add_char buf '\n';
  in
  get_packages arch |> Hashtbl.iter f;
  Buffer.output_buffer stdout buf

let print_usage () =
  let name = Filename.basename Sys.executable_name in
  let name =
    if Filename.check_suffix name ".exe" then
      Filename.chop_suffix name ".exe"
    else
      name
  in
  Printf.eprintf {|usage:
'%s gui'
'%s list'
'%s status pkg'
 or
'%s install pkg1 pkg2 pkg3'|} name name name name;
  prerr_endline "";
  exit 1

let print_status arch pkg =
  let htl = get_packages arch in
  if Hashtbl.mem htl pkg then (
    Printf.printf "installed:%s\n" pkg;
    exit 0
  )
  else (
    Printf.eprintf "not installed:%s\n" pkg;
    exit 1
  )

let () =
  let arch,config =
    let config_file = etc_dir // "depext-cygwin.json" in
    let ch = open_in config_file in
    let j = Yojson.Safe.from_channel ch |> config_of_yojson in
    close_in ch;
    match j with
    | `Error s -> prerr_endline s; exit 2;
    | ` Ok p ->
      let arch = match String.lowercase p.mingw_arch with
      | "mingw64" -> Mingw64
      | "mingw" | "mingw32" -> Mingw32
      | _ -> Printf.eprintf "invalid mingw_arch:%s\n" p.mingw_arch; exit 2
      in
      arch,p
  in
  match Array.to_list Sys.argv with
  | [] | _::[] -> print_usage ()
  | _::"gui"::[] -> gui config;
  | _::"list"::[] -> print_list arch
  | _::"install"::pkgs ->
    (try
      install config arch pkgs;
      exit 0
    with
    | Error s ->
      prerr_endline s;
      exit 1)
  | _::"status"::pkg::[] ->
    print_status arch pkg
  | _ -> print_usage ()
