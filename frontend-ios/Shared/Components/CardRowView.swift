//
//  CardRowView.swift
//  CharChart
//
//  Created by Myles Slack on 2025.10.28.
//

import SwiftUI

struct CardRowView: View {
    let card: Card

    var body: some View {
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
