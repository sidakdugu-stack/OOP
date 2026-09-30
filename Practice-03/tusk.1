import Foundation

struct UserAccount: Equatable {
    let name: String
    let email: String
    let age: Int

    init?(name: String, email: String, age: Int) {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalizedName.count >= 3 else { return nil }

        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let parts = normalizedEmail.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2, !parts[0].isEmpty, !parts[1].isEmpty else { return nil }

        guard (14...120).contains(age) else { return nil }

        self.name = normalizedName
        self.email = normalizedEmail
        self.age = age
    }
}

// --- Проверки ---
assert(UserAccount(name: "  Анна  ", email: "  Anna@Example.COM ", age: 20) != nil)

let acc = UserAccount(name: "  Анна  ", email: "  Anna@Example.COM ", age: 20)!
assert(acc.name == "Анна")                 // пробелы по краям убраны
assert(acc.email == "anna@example.com")    // нижний регистр
assert(acc.age == 20)

// Неуспешные сценарии
assert(UserAccount(name: "Ан", email: "a@b.com", age: 20) == nil)   // имя < 3
assert(UserAccount(name: "Анна", email: "ab.com", age: 20) == nil)  // нет @
assert(UserAccount(name: "Анна", email: "@b.com", age: 20) == nil)  // пустая левая часть
assert(UserAccount(name: "Анна", email: "a@", age: 20) == nil)      // пустая правая часть
assert(UserAccount(name: "Анна", email: "a@b.com", age: 13) == nil) // возраст < 14
assert(UserAccount(name: "Анна", email: "a@b.com", age: 121) == nil)// возраст > 120

print(acc)

// Инварианты: name(trim).count >= 3, email(trim, lower) с одной @ и непустыми частями,
// 14 <= age <= 120. Значения нормализуются в момент создания — некорректный объект не появляется.
