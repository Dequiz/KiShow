//
//  SavedShowsRow.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 30/09/26.
//

import SwiftUI
import SwiftData


struct SavedShowRow: View {
    let show: ShowEntity
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: show.imageShow)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(show.nameShow)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(show.artistShow)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                    Text(show.dataShow, style: .date)
                    if !show.startTimeShow.isEmpty {
                        Text("• \(show.startTimeShow)")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "mappin.and.ellipse")
                    Text("\(show.localShow) — \(show.city)")
                        .lineLimit(1)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
