//
//  CardDetailView.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.28.
//

import SwiftUI

struct CardDetailView: View {
    @StateObject private var vm: CardDetailViewModel
    
    init(cardID: String) {
        _vm = StateObject(wrappedValue: CardDetailViewModel(cardID: cardID))
    }
    
    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading")
            }else if let error = vm.errorMessage {
                Text(error).foregroundStyle(.red)
            }else if let card = vm.card {
                ScrollView {
                    VStack(spacing: 16){
                        AsyncImage(url: card.thumbnailURL) { image in
                            image.resizable().scaledToFit()
                        } placeholder: { ProgressView() }
                        .frame(maxHeight: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Text(card.displayName).font(.title).bold()
                        Text(card.subtitle).foregroundStyle(.secondary)
                        HStack {
                            Text("Rarity: \(card.rarity)")
                            Spacer()
                            Text("Latest: \(card.latestPriceText)").bold()
                        }
                        // Add to Binder
                        addToBinderButton
                    }
                    .padding()
                }
                .navigationTitle("Card Detail")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .task { await vm.load() }
    }
    @ViewBuilder
    private var addToBinderButton: some View {
        switch vm.binderStatus {
        case .idle:
            Button {
                Task { await vm.addToBinder() }
            } label: {
                Label("Add to Binder", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!AuthSession.shared.isAuthenticated)

        case .adding:
            ProgressView().controlSize(.regular)

        case .added:
            Label("Added to Binder", systemImage: "checkmark.circle.fill")
                .foregroundStyle(.green)

        case .failed(let message):
            VStack(spacing: 8) {
                // Use the view-builder form to avoid StringProtocol overloads
                Label {
                    Text(message)                              // ← explicit Text
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .foregroundStyle(.red)

                Button("Try Again") {
                    Task { await vm.addToBinder() }
                }
            }
        }
    }
}
