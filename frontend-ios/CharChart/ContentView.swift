//
//  ContentView.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.12.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var serverStatus: String = "-"   // <-- fixes 'not in scope'
    @State private var isChecking = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("CharChart")
                    .font(.largeTitle).bold()

                // Status line
                HStack(spacing: 8) {
                    Circle()
                        .fill(colorForStatus(serverStatus))
                        .frame(width: 10, height: 10)
                    Text("Server: \(serverStatus)") // "ok" | "-" | "error"
                        .font(.headline)
                }

                // Check Health
                Button {
                    Task {
                        await checkHealth()
                    }
                } label: {
                    if isChecking {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Text("Check Health")
                    }
                }
                .buttonStyle(.borderedProminent)

                if let msg = errorMessage {
                    Text(msg).foregroundStyle(.red)
                }

                // Navigate to Search (optional)
                NavigationLink("Search Cards") {
                    CardSearchView()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
        }
    }

    private func colorForStatus(_ status: String) -> Color {
        switch status.lowercased() {
        case "ok": return .green
        case "-":  return .gray
        default:   return .red
        }
    }

    private func setError(_ message: String) {
        errorMessage = message
        serverStatus = "error"
    }

    private func clearError() {
        errorMessage = nil
    }

    private func checkHealth() async {
        isChecking = true
        clearError()
        defer { isChecking = false }

        do {
            let status = try await APIClient.shared.fetchHealth()
            // status is already a String (e.g., "ok") – don't call .status
            serverStatus = status
        } catch {
            setError("Failed to check server health.")
        }
    }
}

#Preview {
    ContentView()
}
