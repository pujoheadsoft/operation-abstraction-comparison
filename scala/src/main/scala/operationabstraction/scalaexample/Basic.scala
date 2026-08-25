package operationabstraction.scalaexample

object Basic:
  trait ManufacturingCost:
    def materialCost(quantity: Int): Int
    def assemblyCost(quantity: Int): Int

  def calculateTotalCost(manufacturingCost: ManufacturingCost, quantity: Int): Int =
    val material = manufacturingCost.materialCost(quantity)
    val assembly = manufacturingCost.assemblyCost(quantity)
    material + assembly

  object StandardManufacturingCost extends ManufacturingCost:
    def materialCost(quantity: Int): Int =
      quantity * 100

    def assemblyCost(quantity: Int): Int =
      quantity * 50

  def result: Int =
    calculateTotalCost(StandardManufacturingCost, 10)
