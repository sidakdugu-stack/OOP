import Foundation

final class Temperature {
    // Хранится в Цельсиях, менять снаружи нельзя
    private(set) var celsius: Double

    // Абсолютный ноль
    static let absoluteZero: Double = -273.15

    init?(celsius: Double) {
        guard celsius >= Temperature.absoluteZero else { return nil }
        self.celsius = celsius
    }

    @discardableResult
    func setCelsius(_ value: Double) -> Bool {
        guard value >= Temperature.absoluteZero else { return false }
        celsius = value
        return true
    }

    // Вычисляемое свойство с get и set
    var fahrenheit: Double {
        get { celsius * 9 / 5 + 32 }
        set {
            let c = (newValue - 32) * 5 / 9
            // Не нарушаем абсолютный ноль — при некорректном значении оставляем прежнее
            if c >= Temperature.absoluteZero {
                celsius = c
            }
        }
    }
}

// --- Проверки ---
if let t = Temperature(celsius: 0) {
    assert(t.fahrenheit == 32)

    // Успешное изменение через Celsius
    assert(t.setCelsius(100) == true)
    assert(t.fahrenheit == 212)

    // Некорректное значение — состояние сохраняется
    assert(t.setCelsius(-300) == false)
    assert(t.celsius == 100)

    // Изменение через Fahrenheit
    t.fahrenheit = 32
    assert(abs(t.celsius - 0) < 0.0001)

    print("t = \(t.celsius)°C / \(t.fahrenheit)°F")
}

// Некорректный init
assert(Temperature(celsius: -300) == nil)
assert(Temperature(celsius: -273.15) != nil) // ровно абсолютный ноль — допустимо

// Инварианты: celsius >= -273.15, сеттер fahrenheit не нарушает границу
