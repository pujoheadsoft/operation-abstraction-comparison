let greet
    (operations :
      < lookup_name : int -> string; record_greeting : string -> unit; .. >)
    user_id =
  let name = operations#lookup_name user_id in
  operations#record_greeting name;
  "Hello, " ^ name ^ "!"

let console_operations =
  object
    method lookup_name user_id = if user_id = 1 then "Ada" else "Unknown"
    method record_greeting name = Printf.printf "log: greeted %s\n" name
    method implementation_detail = "this extra method is not required"
  end

let () = print_endline (greet console_operations 1)

