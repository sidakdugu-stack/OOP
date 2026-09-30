import Foundation

struct Money: Equatable {
    let amount: Double
    let currency: String

    init?(amount: Double, currency: String) {
        guard amount >= 0 else { return nil }
        guard !currency.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        self.amount = amount
        self.currency = currency
    }

    static func + (lhs: Money, rhs: Money) -> Money? {
        guard lhs.currency == rhs.currency else { return nil }
        return Money(amount: lhs.amount + rhs.amount, currency: lhs.currency)
    }
}

struct Product: Equatable {
    let id: String
    let name: String
    let price: Money

    init?(id: String, name: String, price: Money) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        self.id = id
        self.name = name
        self.price = price
    }
}

struct CartItem: Equatable {
    let product: Product
    private(set) var quantity: Int

    init?(product: Product, quantity: Int) {
        guard quantity > 0 else { return nil }
        self.product = product
        self.quantity = quantity
    }

    mutating func increase(by n: Int) -> Bool {
        guard n > 0 else { return false }
        quantity += n
        return true
    }

    var subtotal: Money {
        Money(amount: product.price.amount * Double(quantity),
              currency: product.price.currency)!
    }
}

final class Cart {
    private(set) var items: [CartItem] = []

    @discardableResult
    func add(_ product: Product, quantity: Int = 1) -> Bool {
        guard quantity > 0 else { return false }
        if let idx = items.firstIndex(where: { $0.product.id == product.id }) {
            return items[idx].increase(by: quantity)
        }
        guard let item = CartItem(product: product, quantity: quantity) else { return false }
        items.append(item)
        return true
    }

    var total: Money? {
        guard let first = items.first else {
            return Money(amount: 0, currency: "RUB")
        }
        return items.reduce(first.subtotal) { acc, item in
            acc.flatMap { $0 + item.subtotal }
        }
    }
}

// --- Проверки ---
guard let price = Money(amount: 100, currency: "RUB"),
      let p1 = Product(id: "p1", name: "Книга", price: price),
      let p2 = Product(id: "p2", name: "Ручка", price: Money(amount: 20, currency: "RUB")!)
else { fatalError() }

assert(Money(amount: -1, currency: "RUB") == nil)
assert(Money(amount: 1, currency: "   ") == nil)
assert(Product(id: "x", name: "", price: price) == nil)

let cart = Cart()
assert(cart.add(p1, quantity: 2) == true)
assert(cart.add(p1, quantity: 3) == true)     // увеличивает существующую позицию
assert(cart.items.first?.quantity == 5)
assert(cart.add(p2) == true)
assert(cart.add(p2, quantity: 0) == false)

// total вычисляется из текущих позиций
let total = cart.total!
assert(total.amount == 520)   // 5*100 + 1*20

// Ссылочная семантика корзины
let cart2 = cart
cart2.add(p2)
assert(cart.items.count == 2)              // изменилось через cart2 — видно в cart
assert(cart.items.last?.quantity == 2)
assert(cart === cart2)

// Другая корзина с теми же товарами — другой объект
let cart3 = Cart()
cart3.add(p1, quantity: 5)
cart3.add(p2)
assert(cart3 === cart == false)
assert(cart3.items.count == cart.items.count)
assert(cart3.total?.amount == cart.total?.amount)

print("Итого: \(cart.total!.amount) \(cart.total!.currency)")

// Выбор типов:
// Money, Product, CartItem — struct: это значения, копирование безопасно.
// Cart — class: корзина должна быть общей, изменения видны всем ссылкам.
