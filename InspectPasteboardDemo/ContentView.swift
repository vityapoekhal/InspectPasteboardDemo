// Copyright © Vitya Poekhal
// https://youtube.com/channel/UC57HY7GHQZrTS4PY5uOroaA
// https://instagram.com/vityapoekhal
// https://habr.com/en/users/vityapoekhal

import SwiftUI

struct ContentView: View {

    @State var pasteboardContents: String = ""

    var body: some View {
        VStack {
            Button("Detect patterns", action: detectPatterns)
                .padding()
            Button("Detect values", action: detectValues)
                .padding()
            Text(pasteboardContents)
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    // MARK: - Detect Patterns

    private func detectPatterns() {
        guard UIPasteboard.general.hasStrings else { return }

        UIPasteboard.general.detectPatterns(
            for: [.probableWebURL, .number, .probableWebSearch],
            completionHandler: handlePatterns
        )
    }

    private func handlePatterns(result: Result<Set<UIPasteboard.DetectionPattern>, Error>) {
        switch result {

        case .success(let detectedPatterns):
            pasteboardContents = detectedPatterns
                .map { $0.name }
                .joined(separator: "\n")

        case .failure(let error):
            pasteboardContents = error.localizedDescription

        }
    }

    // MARK: - Detect Values

    private func detectValues() {
        guard UIPasteboard.general.hasStrings else { return }

        UIPasteboard.general.detectValues(
            for: [.probableWebURL, .number, .probableWebSearch],
            completionHandler: handleValues
        )
    }

    private func handleValues(result: Result<[UIPasteboard.DetectionPattern: Any], Error>) {
        switch result {

        case .success(let values):
            pasteboardContents = values
                .map{ "\($0.name): \($1)" }
                .joined(separator: "\n")

        case .failure(let error):
            pasteboardContents = error.localizedDescription

        }
    }
}


// MARK: - UIPasteboard.DetectionPattern Names

fileprivate extension UIPasteboard.DetectionPattern {
    var name: String {
        switch self {
        case .probableWebURL: return "URL"
        case .number: return "Number"
        case .probableWebSearch: return "Search"
        default: return "Unknown"
        }
    }
}
