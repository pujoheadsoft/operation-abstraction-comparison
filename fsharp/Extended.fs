module Extended

let calculateTotalCost
    (materialCost: int -> int)
    (assemblyCost: int -> int)
    (packagingCost: int -> int)
    (quantity: int)
    : int =
    let material = materialCost quantity
    let assembly = assemblyCost quantity
    let packaging = packagingCost quantity
    material + assembly + packaging

let standardMaterialCost: int -> int =
    fun quantity -> quantity * 100

let standardAssemblyCost: int -> int =
    fun quantity -> quantity * 50

let standardPackagingCost: int -> int =
    fun quantity -> quantity * 20

let result =
    calculateTotalCost
        standardMaterialCost
        standardAssemblyCost
        standardPackagingCost
        10
