package operationabstraction.scalaexample

trait Discount:
  def discountAmount(subtotal: Int): Int

trait Shipping:
  def shippingFee(subtotal: Int): Int

def calculateTotal(discount: Discount, shipping: Shipping, subtotal: Int): Int =
  val discountValue = discount.discountAmount(subtotal)
  val shippingValue = shipping.shippingFee(subtotal)
  subtotal - discountValue + shippingValue

object StandardDiscount extends Discount:
  def discountAmount(subtotal: Int): Int =
    subtotal / 10

object StandardShipping extends Shipping:
  def shippingFee(subtotal: Int): Int =
    if subtotal >= 5000 then 0 else 500

object Main:
  def main(args: Array[String]): Unit =
    println(calculateTotal(StandardDiscount, StandardShipping, 3000))
