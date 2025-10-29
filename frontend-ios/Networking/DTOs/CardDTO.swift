//
//  CardDTO.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.18.
//
import Foundation

/// Exactly what the backend for a card list / detail
/// Keep this strict and boring so decoding is very predictable

struct CardDTO: Decodable, Identifiable {
    let id: String              // backend ID (e.g. "pkm-xy-12-123")
    let name: String            // "Charizard"
    let setName: String?        // "Scarlet & Violet"
    let setCode: String?        // "SV01"
    let number: String?         // "123/198"
    let rarity: String?         // "Rare Holo"
    let imageURL: URL?          // https://...
    
    // Maybe?? : A slim price object, if your search return it
    let latestPrice: Double?    // e.g., 42.50
}
