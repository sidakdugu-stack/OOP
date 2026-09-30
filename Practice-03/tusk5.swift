import Foundation

final class ReportBuilder {
    let numbers: [Int]
    private(set) var buildCount = 0

    init(numbers: [Int]) {
        self.numbers = numbers
    }

    // Ленивое свойство: строится один раз при первом обращении
    lazy var formatted: String = {
        self.buildCount += 1
        let sum = self.numbers.reduce(0, +)
        let avg = self.numbers.isEmpty ? 0 : Double(sum) / Double(self.numbers.count)
        return "сумма: \(sum), среднее: \(avg), элементов: \(self.numbers.count)"
    }()
}

// --- Проверки ---
let report = ReportBuilder(numbers: [1, 2, 3, 4, 5])

// До первого обращения — замыкание не выполнялось
assert(report.buildCount == 0)

let s1 = report.formatted
assert(report.buildCount == 1)
assert(s1 == "сумма: 15, среднее: 3.0, элементов: 5")

// Повторное обращение не пересчитывает
let s2 = report.formatted
assert(report.buildCount == 1)
assert(s1 == s2)

print(s1)
print("buildCount = \(report.buildCount)")

// Почему var, а не let:
// Lazy-свойство хранит значение внутри экземпляра и записывается ОДИН РАЗ при
// первом обращении, уже после завершения init. Компилятор обязан выделить под
// него изменяемую ячейку памяти, потому что на момент создания объекта значения
// ещё нет — оно появится позже. После первого вычисления оно действительно
// больше не меняется (кэш), но синтаксически это запись в хранимое свойство,
// поэтому обязательно var. let требует присваивания в init и запрещает
// последующую запись — с lazy это несовместимо.
