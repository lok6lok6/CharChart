//
//  CardSearchViewModel.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.20.
//
import Foundation
import Combine

@MainActor
final class CardSearchViewModel: ObservableObject {
    @Published var query: String = "" {
        didSet { debouncedSearch() }
    }
    
    @Published private(set) var results: [Card] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoaded : Bool = false // if you reference this in the View
    
    private var searchTask: Task<Void, Never>?
    
    /// call this when query changes OR when user taps Search.
    func debouncedSearch() {
        // Cancel any in -flight debounce/search
        self.searchTask?.cancel()
        
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else {
            results = []
            errorMessage = nil
            return
        }
        
        searchTask = Task { [weak self] in
            // 300ms debounce
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard let self, !Task.isCancelled else {return}
            
            await self.performSearch(for: q)
        }
    }
    
    
    func search() { debouncedSearch() }
    
    private func performSearch(for q: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = Endpoints.cardSearch(query: q)
            let dtos: [CardDTO] = try await APIClient.shared.get(url)
            results = dtos.map(Card.init(dto:))
            isLoading = false
        } catch is CancellationError {
            // ignored (suspended by a new search)
        }catch {
            isLoading = false
            results = []
            errorMessage = "Failed to load data. Check your internet connection and try again."
        }
    }
    
    func loadDetail(id: String) async -> Card? {
        do {
            let dto: CardDTO = try await APIClient.shared.get(Endpoints.cardDetail(id: id))
            return Card(dto: dto)
        } catch {
            errorMessage = "Failed to load data. Check your internet connection and try again."
            return nil
        }
    }
}
