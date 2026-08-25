module Basic

let calculateTotalCost
    (materialCost: int -> int)
    (assemblyCost: int -> int)
    (quantity: int)
    : int =
    let material = materialCost quantity
    let assembly = assemblyCost quantity
    material + assembly

let standardMaterialCost: int -> int =
    fun quantity -> quantity * 100

let standardAssemblyCost: int -> int =
    fun quantity -> quantity * 50

let result =
    calculateTotalCost standardMaterialCost standardAssemblyCost 10
