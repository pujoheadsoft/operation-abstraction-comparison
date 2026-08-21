effect discount {
  ctl discount-amount(subtotal : int) : int
}

effect shipping {
  ctl shipping-fee(subtotal : int) : int
}

fun calculate-total(subtotal : int) : <discount,shipping> int {
  val discount = discount-amount(subtotal)
  val shipping = shipping-fee(subtotal)
  subtotal - discount + shipping
}

fun run-standard-pricing(action : () -> <discount,shipping> int) : int {
  with handler
    ctl discount-amount(subtotal) ->
      resume(subtotal / 10)
  with handler
    ctl shipping-fee(subtotal) ->
      resume(if subtotal >= 5000 then 0 else 500)
  action()
}

fun main() {
  val total = run-standard-pricing(fn() { calculate-total(3000) })
  println(show(total))
}
