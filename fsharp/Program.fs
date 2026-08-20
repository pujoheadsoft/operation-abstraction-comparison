let greet
    (lookupName: int -> string)
    (recordGreeting: string -> unit)
    (userId: int)
    : string =
    let name = lookupName userId
    recordGreeting name
    $"Hello, {name}!"

let lookupNameFromMemory: int -> string =
    fun userId ->
        if userId = 1 then "Ada" else "Unknown"

let recordGreetingToConsole: string -> unit =
    fun name ->
        printfn $"log: greeted {name}"

[<EntryPoint>]
let main _ =
    greet lookupNameFromMemory recordGreetingToConsole 1
    |> printfn "%s"
    0
