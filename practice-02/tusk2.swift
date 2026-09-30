import Foundation

struct Vector2D: Equatable {
    var x: Double
    var y: Double

    var length: Double { (x * x + y * y).squareRoot() }

    // Изменяющий метод структуры требует mutating
    @discardableResult
    mutating func scale(by factor: Double) -> Bool {
        guard factor > 0 else { return false }
        x *= factor
        y *= factor
        return true
    }

    // Возвращает новую копию, оригинал не меняется
    func scaled(by factor: Double) -> Vector2D? {
        guard factor > 0 else { return nil }
        return Vector2D(x: x * factor, y: y * factor)
    }
}

// --- Проверки ---
var v1 = Vector2D(x: 3, y: 4)
assert(v1.length == 5)

// Копия независима
var v2 = v1
v2.x = 10
assert(v1.x == 3)          // оригинал не изменился
assert(v2.x == 10)

// mutating
assert(v1.scale(by: 2) == true)
assert(v1 == Vector2D(x: 6, y: 8))
assert(v1.scale(by: -1) == false)  // некорректный коэффициент
assert(v1 == Vector2D(x: 6, y: 8))

// scaled не меняет исходный
let scaled = v1.scaled(by: 0.5)
assert(scaled == Vector2D(x: 3, y: 4))
assert(v1 == Vector2D(x: 6, y: 8))
assert(v1.scaled(by: 0) == nil)

print("v1 = \(v1), |v1| = \(v1.length)")

// Выбор: struct, потому что вектор — это значение. Его удобно копировать,
// сравнивать по данным, передавать в функции без риска изменить чужой объект.
