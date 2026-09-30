import Foundation

struct Book {
    let id: String
    let title: String
}

final class LibraryMember {
    let id: String
    let name: String
    private(set) var borrowedBooks: [Book] = []

    static let maxBooks = 5

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    var borrowedCount: Int { borrowedBooks.count }

    func hasBorrowed(bookID: String) -> Bool {
        borrowedBooks.contains { $0.id == bookID }
    }

    @discardableResult
    func borrow(_ book: Book) -> Bool {
        guard borrowedBooks.count < LibraryMember.maxBooks else { return false }
        guard !hasBorrowed(bookID: book.id) else { return false }
        borrowedBooks.append(book)
        return true
    }

    @discardableResult
    func returnBook(id: String) -> Bool {
        guard let idx = borrowedBooks.firstIndex(where: { $0.id == id }) else {
            return false
        }
        borrowedBooks.remove(at: idx)
        return true
    }

    func summary() -> String {
        let titles = borrowedBooks.map(\.title).joined(separator: ", ")
        return "\(name): \(titles)"
    }
}

// --- Проверки ---
let bookA = Book(id: "A1", title: "Swift")
let bookB = Book(id: "B2", title: "OOP")
let bookC = Book(id: "C3", title: "Алгоритмы")

let member = LibraryMember(id: "M1", name: "Анна")
assert(member.borrow(bookA) == true)
assert(member.borrow(bookA) == false) // повторно нельзя
assert(member.borrow(bookB) == true)
assert(member.borrowedCount == 2)
assert(member.hasBorrowed(bookID: "A1") == true)

assert(member.returnBook(id: "A1") == true)
assert(member.hasBorrowed(bookID: "A1") == false)
assert(member.returnBook(id: "ZZZ") == false)

print(member.summary())

// Лимит 5 книг
let limited = LibraryMember(id: "M2", name: "Борис")
for i in 0..<5 {
    assert(limited.borrow(Book(id: "X\(i)", title: "Книга \(i)")) == true)
}
assert(limited.borrow(Book(id: "X9", title: "Лишняя")) == false)

// --- Проверка ссылочной семантики ---
let sameMember = member
sameMember.borrow(bookC)
assert(member.hasBorrowed(bookID: "C3") == true)
assert(member.borrowedCount == sameMember.borrowedCount)

// Другой читатель с тем же именем — другой объект
let twin = LibraryMember(id: "M3", name: "Анна")
assert(twin === member == false)
assert(twin.name == member.name)

// Инварианты: borrowedCount <= 5, нет дубликатов по id, id/name неизменяемы
