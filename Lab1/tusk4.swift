import Foundation

final class BankAccount {
    let number: String
    private(set) var balance: Double

    init?(number: String, initialBalance: Double) {
        // Номер не пустой и не из одних пробелов
        let trimmed = number.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard initialBalance >= 0 else { return nil }

        self.number = number
        self.balance = initialBalance
    }

    @discardableResult
    func deposit(_ amount: Double) -> Bool {
        guard amount > 0 else { return false }
        balance += amount
        return true
    }

    @discardableResult
    func withdraw(_ amount: Double) -> Bool {
        guard amount > 0, amount <= balance else { return false }
        balance -= amount
        return true
    }

    var maskedNumber: String {
        let last4 = number.suffix(4)
        return "****\(last4)"
    }

    func description() -> String {
        "Счёт \(maskedNumber): \(balance)"
    }
}

// --- Проверки ---
if let acc = BankAccount(number: "123456781234", initialBalance: 100) {
    assert(acc.maskedNumber == "****1234")

    // Успешные операции
    assert(acc.deposit(50) == true)
    assert(acc.balance == 150)
    assert(acc.withdraw(30) == true)
    assert(acc.balance == 120)

    // Некорректные операции
    assert(acc.deposit(-10) == false)
    assert(acc.withdraw(0) == false)
    assert(acc.withdraw(1000) == false)
    assert(acc.balance == 120)

    print(acc.description()) // Счёт ****1234: 120.0
}

// Пустой номер и номер из пробелов
assert(BankAccount(number: "", initialBalance: 0) == nil)
assert(BankAccount(number: "    ", initialBalance: 0) == nil)

// Отрицательный начальный баланс
assert(BankAccount(number: "111122223333", initialBalance: -1) == nil)

// Инварианты: number непустой (после trim), balance >= 0, суммы > 0
