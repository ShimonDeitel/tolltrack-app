import Foundation
import Combine

@MainActor
final class TolltrackStore: ObservableObject {
    @Published private(set) var entries: [TolltrackEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 15

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = appSupport.appendingPathComponent("Tolltrack", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
    }

    var total: Double {
        entries.reduce(0) { $0 + $1.amount }
    }

    var canAddMore: Bool {
        isPro || entries.count < Self.freeLimit
    }

    @discardableResult
    func add(title: String, amount: Double, date: Date = Date()) -> Bool {
        guard canAddMore else { return false }
        let entry = TolltrackEntry(title: title, amount: amount, date: date)
        entries.insert(entry, at: 0)
        save()
        return true
    }

    func update(_ entry: TolltrackEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: TolltrackEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([TolltrackEntry].self, from: data) {
            entries = decoded
            return
        }
        entries = [
            TolltrackEntry(title: "I-95 Northbound", amount: 6.5, date: Date().addingTimeInterval(-0)),
            TolltrackEntry(title: "Turnpike Exit 8", amount: 3.25, date: Date().addingTimeInterval(-86400)),
            TolltrackEntry(title: "Bridge crossing", amount: 4.0, date: Date().addingTimeInterval(-172800))
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
