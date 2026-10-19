//
//  FavoriteArtists.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftUI
import SwiftData

struct FavoriteArtists: View {
    @Query private var shows: [ShowEntity]
    @State private var activeArtistID: String?

    private var artists: [ChartItemDataArtist] {
        Array(FavoriteArtistViewModel.contarTotalDeItens(shows: shows).prefix(4))
    }

    var body: some View {
        VStack(spacing: 10) {
            GeometryReader { viewport in
                let cardWidth = min(viewport.size.width * 0.7, 250)

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 28) {
                        ForEach(Array(artists.enumerated()), id: \.element.id) { index, artist in
                            artistCard(artist, index: index)
                                .frame(width: cardWidth)
                                .id(artist.id)
                                .visualEffect { content, geometry in
                                    let frame = geometry.frame(in: .scrollView)
                                    let center = viewport.size.width / 2
                                    let distance = min(max((frame.midX - center) / center, -1), 1)
                                    let sideDistance = abs(distance)
                                    let angle = distance * 38
                                    let scale = 1 - sideDistance * 0.2
                                    let opacity = 1 - sideDistance * 0.55
                                    let arcOffset = sideDistance * sideDistance * 42

                                    return content
                                        .scaleEffect(scale)
                                        .opacity(opacity)
                                        .rotation3DEffect(
                                            .degrees(angle),
                                            axis: (x: 0, y: 1, z: 0),
                                            perspective: 0.65
                                        )
                                        .offset(y: arcOffset)
                                }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, (viewport.size.width - cardWidth) / 2)
                    .padding(.vertical, 4)
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeArtistID, anchor: .center)
            }
            .frame(height: 260)

            HStack(spacing: 7) {
                ForEach(artists) { artist in
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                            activeArtistID = artist.id
                        }
                    } label: {
                        Capsule()
                            .fill(activeArtistID == artist.id ? Color.mainPink : Color.secondary.opacity(0.3))
                            .frame(width: activeArtistID == artist.id ? 20 : 7, height: 7)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Mostrar \(artist.artist)")
                }
            }
            .padding(.bottom, 4)
        }
        .onAppear {
            if activeArtistID == nil {
                activeArtistID = artists.first?.id
            }
        }
    }

    private func artistCard(_ artist: ChartItemDataArtist, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .bottomLeading) {
                Group {
                    if let imageData = artist.imageData,
                       let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(Color.mainPurple.opacity(0.2).gradient)
                            .overlay {
                                Image(systemName: "music.mic")
                                    .font(.system(size: 42, weight: .medium))
                                    .foregroundStyle(Color.mainPurple)
                            }
                    }
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.78)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(index + 1)º MAIS OUVIDO")
                        .font(.caption2.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(.white.opacity(0.85))

                    Text(artist.artist)
                        .font(.title3.weight(.bold))
                        .lineLimit(2)
                        .foregroundStyle(.white)
                }
                .padding(14)
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            Text("\(artist.count) \(artist.count == 1 ? "show" : "shows")")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
        }
    }
}
