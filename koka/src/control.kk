effect stop {
  ctl stop() : ()
}

fun control-example() : <stop,io> () {
  println("before")
  stop()
  println("after")
}

fun run-control-example() : io () {
  with handler
    ctl stop() -> ()
  control-example()
}

fun main() {
  run-control-example()
}
