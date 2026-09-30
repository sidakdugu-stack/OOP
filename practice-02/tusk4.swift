struct Address: Equatable {
    var city: String
}

struct OrderDraft {
    var number: Int
    var address: Address
}

let addr2 = Address(city: "Москва")
var f = OrderDraft(number: 1, address: addr2)
var s = f
s.number = 2
s.address.city = "Питер"

assert(f.number == 1)
assert(s.number == 2)
assert(f.address.city == "Москва")   // черновики полностью независимы
assert(s.address.city == "Питер")

print("f: \(f), s: \(s)")
