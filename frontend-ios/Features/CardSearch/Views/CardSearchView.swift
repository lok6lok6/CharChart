//
//  CardSearchView.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.21.
//

import SwiftUI

struct CardSearchView: View {
    @StateObject private var vm = CardSearchViewModel()
    @State private var selectedCard: Card?
    
    var body: some View {
        VStack(spacing: 16){
            HStack{
                TextField("Search cards (name, set, number)...", text: $vm.query)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                    .onSubmit { vm.search() }
                    
                Button("Search"){ vm.search()}
                    .buttonStyle(.borderedProminent)
            }
            //Loading / Error
            if vm.isLoaded {
                ProgressView("Searching...")
            } else if let message = vm.errorMessage {
                Text(message).foregroundStyle(Color.red)
            }
            
            List(vm.results){ card in
                Button{
                    selectedCard = card
                } label: {
                    HStack(spacing: 12){
                        AsyncImage(url: card.thumbnailURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Rectangle().fill(Color.gray.opacity(0.15))
                        }
                        .frame(width: 48, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        VStack(alignment: .leading, spacing: 4){
                            Text(card.displayName).font(.headline)
                            Text(card.subtitle).font(.subheadline).foregroundStyle(.secondary)
                            HStack{
                                Text(card.rarity).font(.caption)
                                Spacer()
                                Text(card.latestPriceText).font(.caption).bold()
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .refreshable {vm.search()} // pull to refresh
        }
        .padding()
        .navigationTitle("Search Cards")
        
        List(vm.results) { card in
            NavigationLink {
                CardDetailView(cardID: card.id)
            } label: {
                HStack(spacing: 12) {
                    AsyncImage(url: card.thumbnailURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.15))
                    }
                    .frame(width: 48, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.displayName).font(.headline)
                        Text(card.subtitle).font(.subheadline).foregroundStyle(.secondary)
                        HStack {
                            Text(card.rarity).font(.caption)
                            Spacer()
                            Text(card.latestPriceText).font(.caption).bold()
                        }
                    }
                }
            }
        }
    }
}

private struct CardDetailPreview: View {
    let cardID: String
    @State private var detail: Card?
    @State private var isLoading = true
    @State private var error: String?
    
    var body: some View {
        NavigationStack {
            Group{
                if isLoading {
                    ProgressView("Loading detail...")
                }else if let error {
                    Text(error).foregroundStyle(Color.red)
                }else if let card = detail {
                    VStack(spacing: 12){
                        AsyncImage(url: card.thumbnailURL){$0.resizable().scaledToFit()} placeholder: {ProgressView()}
                            .frame(maxHeight: 240)
                        Text(card.displayName).font(.title).bold()
                        Text(card.subtitle).foregroundStyle(.secondary)
                        Text("Rarity: \(card.rarity)")
                        Text("Latest: \(card.latestPriceText)").bold()
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Card Detail")
            .task{
                let vm = CardSearchViewModel()
                if let c = await vm.loadDetail(id: cardID) {
                    detail = c
                }else {
                    error = "Failed to load card detail."
                }
                isLoading = false
            }
        }
    }
}

//private struct CardDetailPreview: View {
//    let card: Card
//    
//    var body: some View {
//        VStack(spacing: 12){
//            AsyncImage(url: card.thumbnailURL) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//            } placeholder: {
//                ProgressView()
//            }
//            Text(card.displayName).font(.title).bold()
//            Text(card.subtitle).foregroundStyle(.secondary)
//            Text("Rarity: \(card.rarity)")
//            Text("Latest: \(card.latestPriceText)").bold()
//            Spacer()
//        }
//        .padding()
//    }
//}


