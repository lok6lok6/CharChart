//
//  Card.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.18.
//

import Foundation

/// UI-Friendly Card model built from CardDTO
/// Lives in CardDetail/Models but is reused by Search too

struct Card: Identifiable, Equatable {
    let id: String
    let displayName: String
    let subtitle: String            // e.g., "SV01 • 123/198" or set name
    let rarity: String
    let thumbnailURL: URL?
    let latestPriceText: String     // already formated for the UI
    
    init(dto: CardDTO) {
        self.id = dto.id
        self.displayName = dto.name
        let setBits = [dto.setCode, dto.number].compactMap { $0 }.joined(separator: " • ")
        self.subtitle = setBits.isEmpty ? (dto.setName ?? "") : setBits
        self.rarity = dto.rarity ?? "—"
        self.thumbnailURL = dto.imageURL
        if let price = dto.latestPrice {
            self.latestPriceText = String(format: "$%.2f", price)
        } else {
            self.latestPriceText = "—"
        }
        
    }
    
}
