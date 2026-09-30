import Foundation

struct Track: Equatable {
    let id: String
    let title: String
}

final class Playlist {
    let id: String
    var name: String
    private(set) var tracks: [Track] = []

    init?(id: String, name: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        self.id = id
        self.name = name
    }

    @discardableResult
    func add(_ track: Track) -> Bool {
        guard !track.title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !tracks.contains(where: { $0.id == track.id }) else { return false }
        tracks.append(track)
        return true
    }

    @discardableResult
    func remove(id: String) -> Bool {
        guard let idx = tracks.firstIndex(where: { $0.id == id }) else { return false }
        tracks.remove(at: idx)
        return true
    }
}

// --- Проверки ---
guard let p1 = Playlist(id: "P1", name: "Любимое") else { fatalError() }
assert(Playlist(id: "P2", name: "   ") == nil)

assert(p1.add(Track(id: "t1", title: "Song A")) == true)
assert(p1.add(Track(id: "t1", title: "Song A")) == false)  // дубликат
assert(p1.add(Track(id: "t2", title: "")) == false)        // пустое название
assert(p1.tracks.count == 1)

// Ссылочная семантика
let p2 = p1
p2.add(Track(id: "t3", title: "Song C"))
assert(p1.tracks.count == 2)      // изменение видно через p1
assert(p1 === p2)                 // это один объект

// Второй плейлист с теми же данными — другой объект
guard let p3 = Playlist(id: "P1", name: "Любимое") else { fatalError() }
assert(p3 === p1 == false)

print("p1: \(p1.tracks.map(\.title))")

// Выбор: class, потому что плейлист должен совместно использоваться
// несколькими частями программы и меняться в одном месте, отражаясь везде.
