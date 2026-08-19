effect name-lookup {
  ctl lookup-name(user-id : int) : string
}

effect greeting-recorder {
  ctl record-greeting(name : string) : ()
}

fun greet(user-id : int) : <name-lookup,greeting-recorder> string {
  val name = lookup-name(user-id)
  record-greeting(name)
  "Hello, " ++ name ++ "!"
}

fun run-console(action : () -> <name-lookup,greeting-recorder> string) : io string {
  with handler
    ctl lookup-name(user-id) ->
      resume(if user-id == 1 then "Ada" else "Unknown")
  with handler
    ctl record-greeting(name) -> {
      println("log: greeted " ++ name)
      resume(())
    }
  action()
}

fun main() {
  val message = run-console(fn() { greet(1) })
  println(message)
}
