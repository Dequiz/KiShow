//
//  TicketSelection.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct TicketSelection: View {

@State var selectedTheme: TicketTheme = .purple
@State var pressed = false
@State var upSheet = false
private let baseWidth: CGFloat = 350.0
var artistName: String
var eventName: String
var localName: String
var dateEvent: Date

    var body: some View {
        Ticket(artistName: artistName, eventName: eventName, localName:localName, dateEvent: dateEvent, theme: selectedTheme)
            .onLongPressGesture(minimumDuration: 0.5) { upSheet.toggle() }
            .sheet (isPresented: $upSheet) {
                NavigationStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: -20){
                            ForEach(TicketTheme.allCases) { theme in
                                Image(theme.imageName)
                                    .rotationEffect(.degrees(45))
                                    .scaledToFit()
                                    .frame(height: 350)
                                    .onTapGesture {
                                        selectedTheme = theme
                                        upSheet.toggle()
                                    }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 40)
                    .presentationDetents([.medium])
                    .navigationTitle("Personalize seu Ticket")
                    .navigationBarTitleDisplayMode(.inline)
                  
                }
        }
            
    }
}
