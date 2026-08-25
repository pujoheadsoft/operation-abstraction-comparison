effect manufacturing-cost {
  ctl material-cost(quantity : int) : int
  ctl assembly-cost(quantity : int) : int
}

effect packaging-cost {
  ctl packaging-cost(quantity : int) : int
}

fun calculate-total-cost(quantity : int) : <manufacturing-cost,packaging-cost> int {
  val material = material-cost(quantity)
  val assembly = assembly-cost(quantity)
  val packaging = packaging-cost(quantity)
  material + assembly + packaging
}

fun run-standard-cost(action : () -> <manufacturing-cost,packaging-cost> int) : int {
  with handler
    ctl material-cost(quantity) -> resume(quantity * 100)
    ctl assembly-cost(quantity) -> resume(quantity * 50)
  with handler
    ctl packaging-cost(quantity) -> resume(quantity * 20)
  action()
}

fun main() {
  val total = run-standard-cost(fn() { calculate-total-cost(10) })
  println(show(total))
}
