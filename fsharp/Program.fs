let greet
    (lookupName: int -> string)
    (recordGreeting: string -> unit)
    (userId: int)
    : string =
    let name = lookupName userId
    recordGreeting name
    $"Hello, {name}!"

let lookupName: int -> string =
    fun userId ->
        if userId = 1 then "Ada" else "Unknown"

let recordGreeting: string -> unit =
    fun name ->
        printfn $"log: greeted {name}"

[<EntryPoint>]
let main _ =
    greet lookupName recordGreeting 1
    |> printfn "%s"
    0
