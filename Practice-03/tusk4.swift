import Foundation

class Vehicle {
    let id: String
    var mileage: Double

    init?(id: String, mileage: Double) {
        let trimmed = id.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard mileage >= 0 else { return nil }
        self.id = trimmed
        self.mileage = mileage
    }

    // Convenience того же класса — делегирует свой designated
    convenience init?(id: String) {
        self.init(id: id, mileage: 0)
    }
}

final class ElectricCar: Vehicle {
    let batteryCapacity: Double     // kWh
    var charge: Double              // 0...100

    init?(id: String,
          mileage: Double,
          batteryCapacity: Double,
          charge: Double) {
        // Сначала собственные свойства подкласса
        guard batteryCapacity > 0 else { return nil }
        guard (0...100).contains(charge) else { return nil }
        self.batteryCapacity = batteryCapacity
        self.charge = charge

        // Затем — фаза 1 для базового класса
        super.init(id: id, mileage: mileage)
    }

    // Удобный путь: делегирует designated своего класса
    convenience init?(id: String, batteryCapacity: Double) {
        self.init(id: id, mileage: 0, batteryCapacity: batteryCapacity, charge: 100)
    }

    override init?(id: String, mileage: Double) {
        // Здесь нужен собственный designated: базовый без батареи не подходит.
        self.batteryCapacity = 60
        self.charge = 100
        super.init(id: id, mileage: mileage)
    }
}

// --- Проверки ---
let car1 = ElectricCar(id: "EV-1", mileage: 1000, batteryCapacity: 75, charge: 50)
assert(car1 != nil)
assert(car1!.id == "EV-1")
assert(car1!.mileage == 1000)
assert(car1!.batteryCapacity == 75)
assert(car1!.charge == 50)

let car2 = ElectricCar(id: "EV-2", batteryCapacity: 100)
assert(car2 != nil)
assert(car2!.mileage == 0)
assert(car2!.charge == 100)

// Границы инвариантов
assert(ElectricCar(id: "", mileage: 0, batteryCapacity: 75, charge: 50) == nil)   // id пустой
assert(ElectricCar(id: "  ", mileage: 0, batteryCapacity: 75, charge: 50) == nil) // id из пробелов
assert(ElectricCar(id: "EV", mileage: -1, batteryCapacity: 75, charge: 50) == nil)// пробег < 0
assert(ElectricCar(id: "EV", mileage: 0, batteryCapacity: 0, charge: 50) == nil)  // батарея <= 0
assert(ElectricCar(id: "EV", mileage: 0, batteryCapacity: 75, charge: -1) == nil) // заряд < 0
assert(ElectricCar(id: "EV", mileage: 0, batteryCapacity: 75, charge: 101) == nil)// заряд > 100

// На границах допустимо
assert(ElectricCar(id: "EV", mileage: 0, batteryCapacity: 75, charge: 0) != nil)
assert(ElectricCar(id: "EV", mileage: 0, batteryCapacity: 75, charge: 100) != nil)

print(car1!, car2!)

// Порядок инициализации ElectricCar (двухфазная):
// Фаза 1:
//   1. Проверяются инварианты подкласса (batteryCapacity > 0, 0...100).
//   2. Присваиваются собственные хранимые свойства: batteryCapacity, charge.
//   3. Вызывается super.init(id:mileage:) — базовый класс проверяет свои инварианты
//      (непустой id, mileage >= 0) и заполняет свои свойства.
// Фаза 2 (начинается автоматически после возврата из super.init):
//   Объект полностью инициализирован; можно вызывать методы, использовать self.
// Подкласс присваивает собственные свойства ДО super.init, потому что до вызова
// super.init использовать self нельзя — базовые свойства ещё не заполнены.
