import Foundation

final class Connection {
    let id: String
    private(set) var isOpen = false
    private(set) var closeCount = 0
    var onClose: (() -> Void)?

    init(id: String) {
        self.id = id
        self.isOpen = true
    }

    @discardableResult
    func send(_ message: String) -> Bool {
        guard isOpen else { return false }
        guard !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return true
    }

    // Идемпотентное закрытие
    func close() {
        guard isOpen else { return }   // уже закрыто — ничего не делаем
        isOpen = false
        closeCount += 1
        onClose?()
    }

    deinit {
        // Резервная очистка: если close() не был вызван вручную
        close()
    }
}

// --- Сценарий 1: явное close ---
var closeEvents1 = 0
let c1 = Connection(id: "C1")
c1.onClose = { closeEvents1 += 1 }

assert(c1.isOpen == true)
assert(c1.send("hello") == true)
assert(c1.send("   ") == false)   // пустое сообщение

c1.close()
assert(c1.isOpen == false)
assert(c1.closeCount == 1)
assert(closeEvents1 == 1)
assert(c1.send("after close") == false)   // отправка после закрытия

// Повторное close идемпотентно: onClose больше не вызывается
c1.close()
assert(c1.closeCount == 1)
assert(closeEvents1 == 1)

print("Сценарий 1: закрытий \(c1.closeCount), событий onClose \(closeEvents1)")

// --- Сценарий 2: без явного close, полагаемся на deinit ---
var closeEvents2 = 0
do {
    let c2 = Connection(id: "C2")
    c2.onClose = { closeEvents2 += 1 }
    assert(c2.isOpen == true)
    // close() не вызываем — должен сработать deinit после выхода из области
}
assert(closeEvents2 == 1)   // резервная очистка произошла ровно один раз

print("Сценарий 2: событий onClose \(closeEvents2)")

// Инварианты: после close isOpen == false, closeCount == 1, onClose вызывается один раз.
// Идемпотентность: guard isOpen else { return } не даёт повторно вызвать onClose.
// Тест не зависит от точной строки выполнения deinit — проверяется лишь количество
// вызовов onClose после завершения области видимости.
