//
//  CardDetailViewModel.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.25.
//

import Foundation
import Combine

@MainActor
final class CardDetailViewModel: ObservableObject {
    @Published private(set) var card: Card?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    let cardID: String
    
    enum BinderStatus: Equatable {
        case idle
        case adding
        case added
        case failed(message: String)
    }
    
    @Published private(set) var binderStatus: BinderStatus = .idle

    init(cardID: String){
        self.cardID = cardID
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let dto: CardDTO = try await APIClient.shared.get(Endpoints.cardDetail(id: cardID))
            card = Card(dto: dto)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to load card with ID: \(cardID)"
        }
    }
    
    func addToBinder() async {
        guard AuthSession.shared.isAuthenticated else {
            binderStatus = .failed(message: "Please log in first.")
            return
        }

        binderStatus = .adding
        do {
            let body = BinderAddRequestDTO(cardID: cardID)

            // capture the result instead of discarding it
            let response: BinderAddResponseDTO = try await APIClient.shared.post(
                Endpoints.binderAdd(),
                body: body
            )

            binderStatus = response.success
                ? .added
                : .failed(message: response.message ?? "Failed to add to Binder.")
        } catch {
            binderStatus = .failed(message: "Failed to add to Binder.")
        }
    }
}
