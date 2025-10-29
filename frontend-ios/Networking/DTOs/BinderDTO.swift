//
//  BinderDTO.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.28.
//

import Foundation

struct BinderAddRequestDTO: Encodable {
    let cardID: String
}

struct BinderAddResponseDTO: Decodable {
    let success: Bool
    let message: String?
}
