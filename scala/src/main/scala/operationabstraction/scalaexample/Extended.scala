package operationabstraction.scalaexample

object Extended:
  trait ManufacturingCost:
    def materialCost(quantity: Int): Int
    def assemblyCost(quantity: Int): Int

  trait PackagingCost:
    def packagingCost(quantity: Int): Int

  def calculateTotalCost(
      manufacturingCost: ManufacturingCost,
      packagingCost: PackagingCost,
      quantity: Int
  ): Int =
    val material = manufacturingCost.materialCost(quantity)
    val assembly = manufacturingCost.assemblyCost(quantity)
    val packaging = packagingCost.packagingCost(quantity)
    material + assembly + packaging

  object StandardManufacturingCost extends ManufacturingCost:
    def materialCost(quantity: Int): Int =
      quantity * 100

    def assemblyCost(quantity: Int): Int =
      quantity * 50

  object StandardPackagingCost extends PackagingCost:
    def packagingCost(quantity: Int): Int =
      quantity * 20

  def result: Int =
    calculateTotalCost(StandardManufacturingCost, StandardPackagingCost, 10)
