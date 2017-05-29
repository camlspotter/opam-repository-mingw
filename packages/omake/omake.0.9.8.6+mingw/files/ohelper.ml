let max_buf_len = 8192

let input_line ch =
  let str = input_line ch in
  let len = String.length str in
  if len = 0 || str.[len-1] <> '\r' then
    str
  else
    String.sub str 0 (len - 1)

let process_entry str =
  (* non-zero length because of Str.split *)
  if str.[0] <> '\\' then
    CygwinPath.to_native str
  else
    str

let rec handle_entry buf = function
| [] -> Buffer.add_char buf '\n'
| hd::tl ->
  Buffer.add_string buf (process_entry hd);
  if tl <> [] then
    Buffer.add_char buf ' ';
  handle_entry buf tl

let rex = Str.regexp "[ \t]+"

let rec cat buf =
  let further =
    try
      handle_entry buf (Str.split rex (input_line stdin));
      true
    with
    | End_of_file -> false
  in
  let len = Buffer.length buf in
  if len >= max_buf_len || (further = false && len > 0 ) then (
    Buffer.output_buffer stdout buf;
    Buffer.clear buf;
  );
  if further then
    cat buf

let () =
  set_binary_mode_out stdout true;
  cat (Buffer.create max_buf_len);
  exit 0
