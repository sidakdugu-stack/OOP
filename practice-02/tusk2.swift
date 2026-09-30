import Foundation

struct EmailAddress: Equatable {
    let value: String

    init?(_ raw: String) {
        let parts = raw.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2,
              !parts[0].isEmpty,
              !parts[1].isEmpty else { return nil }
        self.value = raw
    }
}

struct StudentRecord: Equatable {
    let name: String
    let email: EmailAddress
    private(set) var grades: [Int]

    init?(name: String, email: EmailAddress, grades: [Int] = []) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        guard grades.allSatisfy({ (1...5).contains($0) }) else { return nil }
        self.name = name
        self.email = email
        self.grades = grades
    }

    var average: Double {
        grades.isEmpty ? 0 : Double(grades.reduce(0, +)) / Double(grades.count)
    }

    // Возвращает изменённую копию, оригинал не трогает
    func addingGrade(_ grade: Int) -> StudentRecord? {
        guard (1...5).contains(grade) else { return nil }
        var copy = self
        copy.grades.append(grade)
        return copy
    }
}

// --- Проверки ---
assert(EmailAddress("a@b") != nil)
assert(EmailAddress("ab") == nil)         // нет @
assert(EmailAddress("@b") == nil)         // пустая левая часть
assert(EmailAddress("a@") == nil)         // пустая правая часть
assert(EmailAddress("a@@b") == nil)       // две @

guard let email = EmailAddress("student@example.com"),
      let record = StudentRecord(name: "Анна", email: email, grades: [4, 5]) else {
    fatalError("setup failed")
}

assert(record.average == 4.5)
assert(StudentRecord(name: "X", email: email, grades: [0]) == nil)  // оценка вне диапазона
assert(StudentRecord(name: "  ", email: email) == nil)              // пустое имя

// addingGrade возвращает копию, оригинал не меняется
let updated = record.addingGrade(3)
assert(updated?.grades == [4, 5, 3])
assert(record.grades == [4, 5])            // исходная запись не изменилась
assert(record.addingGrade(6) == nil)

let empty = StudentRecord(name: "Пусто", email: email)
assert(empty?.average == 0)

print("Средний балл: \(record.average), после добавления: \(updated!.average)")

// Выбор: struct, потому что учебная запись — это снимок значения.
// Её удобно хранить в массивах, передавать, сравнивать. Копия не влияет на оригинал.
