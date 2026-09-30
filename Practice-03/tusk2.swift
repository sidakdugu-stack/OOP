import Foundation

struct Temperature: Equatable {
    let celsius: Double

    static let absoluteZero: Double = -273.15

    // Единый основной путь инициализации
    init?(celsius: Double) {
        guard celsius >= Temperature.absoluteZero else { return nil }
        self.celsius = celsius
    }

    // Инициализатор Фаренгейта делегирует основному
    init?(fahrenheit: Double) {
        self.init(celsius: (fahrenheit - 32) * 5 / 9)
    }

    // Инициализатор Кельвина делегирует основному
    init?(kelvin: Double) {
        self.init(celsius: kelvin - 273.15)
    }

    var fahrenheit: Double { celsius * 9 / 5 + 32 }
    var kelvin: Double { celsius + 273.15 }
}

// --- Проверки ---
let t1 = Temperature(celsius: 0)
assert(t1 != nil)
assert(t1!.fahrenheit == 32)
assert(t1!.kelvin == 273.15)

let t2 = Temperature(fahrenheit: 212)
assert(t2 != nil)
assert(abs(t2!.celsius - 100) < 0.0001)
assert(abs(t2!.kelvin - 373.15) < 0.0001)

let t3 = Temperature(kelvin: 0)
assert(t3 != nil)
assert(abs(t3!.celsius + 273.15) < 0.0001)
assert(abs(t3!.fahrenheit + 459.67) < 0.0001)

// Ниже абсолютного нуля — все пути возвращают nil
assert(Temperature(celsius: -274) == nil)
assert(Temperature(fahrenheit: -500) == nil)
assert(Temperature(kelvin: -1) == nil)

// На самой границе — допустимо
assert(Temperature(celsius: -273.15) != nil)
assert(Temperature(kelvin: 0) != nil)

print(t1!, t2!, t3!)

// Проверка абсолютного нуля живёт только в init?(celsius:) — дублирования нет.
// Остальные инициализаторы делегируют через self.init(celsius:).
