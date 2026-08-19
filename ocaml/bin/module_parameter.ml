module type NAME_LOOKUP = sig
  val lookup_name : int -> string
end

module type GREETING_RECORDER = sig
  val record_greeting : string -> unit
end

module Make_greeter
    (Name_lookup : NAME_LOOKUP)
    (Greeting_recorder : GREETING_RECORDER) = struct
  let greet user_id =
    let name = Name_lookup.lookup_name user_id in
    Greeting_recorder.record_greeting name;
    "Hello, " ^ name ^ "!"
end

module Console_name_lookup = struct
  let lookup_name user_id = if user_id = 1 then "Ada" else "Unknown"
end

module Console_greeting_recorder = struct
  let record_greeting name = Printf.printf "log: greeted %s\n" name
end

module Greeter =
  Make_greeter (Console_name_lookup) (Console_greeting_recorder)

let () = print_endline (Greeter.greet 1)

