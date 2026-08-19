import gleam/io

fn greet(
  lookup_name: fn(Int) -> String,
  record_greeting: fn(String) -> Nil,
  user_id: Int,
) -> String {
  let name = lookup_name(user_id)
  record_greeting(name)
  "Hello, " <> name <> "!"
}

fn lookup_name(user_id: Int) -> String {
  case user_id {
    1 -> "Ada"
    _ -> "Unknown"
  }
}

fn record_greeting(name: String) -> Nil {
  io.println("log: greeted " <> name)
}

pub fn main() -> Nil {
  greet(lookup_name, record_greeting, 1)
  |> io.println
}
