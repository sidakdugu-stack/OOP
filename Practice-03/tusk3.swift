import Foundation

final class Document {
    let id: UUID
    let title: String
    let createdAt: Date
    var body: String

    // Единственный designated initializer — полностью заполняет объект
    init(id: UUID, title: String, createdAt: Date, body: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.id = id
        self.title = trimmed.isEmpty ? "Без названия" : trimmed
        self.createdAt = createdAt
        self.body = body
    }

    // Первый convenience: генерирует UUID и Date, делегирует designated
    convenience init(title: String, body: String) {
        self.init(id: UUID(), title: title, createdAt: Date(), body: body)
    }

    // Второй convenience: пустое тело, делегирует первому convenience
    convenience init(title: String) {
        self.init(title: title, body: "")
    }
}

// --- Проверки ---
let d1 = Document(id: UUID(), title: "  Отчёт  ", createdAt: Date(), body: "текст")
assert(d1.title == "Отчёт")
assert(d1.body == "текст")

let d2 = Document(title: "Заметка", body: "содержимое")
assert(d2.title == "Заметка")
assert(d2.body == "содержимое")

let d3 = Document(title: "Только заголовок")
assert(d3.title == "Только заголовок")
assert(d3.body == "")

// Нормализация некорректного заголовка к документированному значению
let d4 = Document(title: "   ")
assert(d4.title == "Без названия")

print(d1.title, d2.title, d3.title, d4.title)

// Выбранное решение: нормализация заголовка к "Без названия".
// Причина: документ — сущность, для которой пустой заголовок это лишь неудобство,
// а не нарушение предметной области. Проваливающиеся инициализаторы заставили бы
// клиентский код всюду обрабатывать optional без реальной пользы. Одно документированное
// значение "Без названия" делает все пути создания безопасными и предсказуемыми.
