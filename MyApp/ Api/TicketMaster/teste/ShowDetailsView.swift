//
//  ShowDetailsView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 30/09/26.
//

import SwiftUI

struct ShowDetailView: View {
    let show: ShowEntity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: show.imageShow)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    default:
                        Color.gray.opacity(0.2)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipped()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(show.nameShow)
                        .font(.title2.bold())
                    
                    Label(show.artistShow, systemImage: "person.fill")
                    
                    Label(show.genderShow, systemImage: "tag.fill")
                    
                    Label {
                        Text(show.dataShow, style: .date)
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
                    if !show.startTimeShow.isEmpty {
                        Label(show.startTimeShow, systemImage: "clock.fill")
                    }
                    
                    Label("\(show.localShow)", systemImage: "building.2.fill")
                    
                    Label(show.addressShow, systemImage: "mappin.circle.fill")
                    
                    Label(show.city, systemImage: "map.fill")
                    
                    if let url = URL(string: show.urlShow), !show.urlShow.isEmpty {
                        Link(destination: url) {
                            Label("Abrir no Ticketmaster", systemImage: "link")
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}
