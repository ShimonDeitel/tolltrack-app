import SwiftUI

/// Unique visual identity for Tolltrack - Toll Road Log.
enum Theme {
    static let accent = Color(red: 0.757, green: 0.267, blue: 0.235)
    static let background = Color(red: 0.114, green: 0.071, blue: 0.067)
    static let card = background.opacity(0.6)
    static let positive = Color.green
    static let negative = Color.red.opacity(0.85)

    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let monoFont = Font.system(.body, design: .monospaced).weight(.semibold)
}
