import Foundation

final class Counter {
    // Хранимое состояние экземпляра
    private(set) var value: Int = 0

    // Состояние типа (общее для всех экземпляров)
    private static var _createdCount: Int = 0
    static var createdCount: Int { _createdCount }

    init() {
        Counter._createdCount += 1
    }

    func increment() {
        value += 1
    }

    @discardableResult
    func increment(by amount: Int) -> Bool {
        guard amount > 0 else { return false }
        value += amount
        return true
    }

    func reset() {
        value = 0
    }

    static func howManyCreated() -> Int {
        _createdCount
    }
}

// --- Проверки ---
let before = Counter.createdCount

let a = Counter()
let b = Counter()

// Значения независимы
a.increment()
a.increment(by: 5)
assert(a.value == 6)
assert(b.value == 0)

// Некорректный аргумент
assert(a.increment(by: -1) == false)
assert(a.value == 6)

// reset
b.reset()
assert(b.value == 0)

// createdCount общий для типа
assert(Counter.createdCount == before + 2)
assert(Counter.howManyCreated() == before + 2)

print("a = \(a.value), b = \(b.value), создано = \(Counter.createdCount)")

// Инварианты: value >= 0, amount > 0, createdCount учитывает только успешные init
