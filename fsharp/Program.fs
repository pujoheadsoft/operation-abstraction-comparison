let calculateTotal
    (discountAmount: int -> int)
    (shippingFee: int -> int)
    (subtotal: int)
    : int =
    let discount = discountAmount subtotal
    let shipping = shippingFee subtotal
    subtotal - discount + shipping

let standardDiscountAmount: int -> int =
    fun subtotal -> subtotal / 10

let standardShippingFee: int -> int =
    fun subtotal ->
        if subtotal >= 5000 then 0 else 500

[<EntryPoint>]
let main _ =
    calculateTotal standardDiscountAmount standardShippingFee 3000
    |> printfn "%d"
    0
