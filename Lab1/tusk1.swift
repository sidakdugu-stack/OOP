import Foundation

final class Rectangle {
    // Стороны только для чтения снаружи
    private(set) var width: Double
    private(set) var height: Double

    // Проваливающийся инициализатор: стороны должны быть > 0
    init?(width: Double, height: Double) {
        guard width > 0, height > 0 else { return nil }
        self.width = width
        self.height = height
    }

    // Вычисляемые свойства только для чтения
    var area: Double { width * height }
    var perimeter: Double { 2 * (width + height) }
    var isSquare: Bool { width == height }

    // Масштабирование с проверкой коэффициента
    @discardableResult
    func scale(by factor: Double) -> Bool {
        guard factor > 0 else { return false }
        width *= factor
        height *= factor
        return true
    }
}

// --- Проверки ---
if let r = Rectangle(width: 4, height: 5) {
    assert(r.area == 20)
    assert(r.perimeter == 18)
    assert(r.isSquare == false)
    assert(r.scale(by: 2) == true)
    assert(r.width == 8 && r.height == 10)

    // Пример успешной операции
    print("Площадь: \(r.area), периметр: \(r.perimeter)")

    // Некорректный коэффициент
    assert(r.scale(by: -1) == false)
    assert(r.width == 8) // состояние не изменилось
}

// Некорректные стороны → nil
assert(Rectangle(width: 0, height: 5) == nil)
assert(Rectangle(width: -3, height: 5) == nil)

// Инварианты: width > 0, height > 0, factor > 0
