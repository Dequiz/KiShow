//
//  TicketSelection.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI
import SwiftData

struct TicketSelection: View {

@Environment(\.modelContext) private var context
@State private var selectedTheme: TicketTheme
@State var pressed = false
@State var upSheet = false
private let baseWidth: CGFloat = 350.0
var artistName: String
var eventName: String
var localName: String
var dateEvent: Date
let event: EventEntity

    init(artistName: String, eventName: String, localName: String, dateEvent: Date, event: EventEntity) {
        self.artistName = artistName
        self.eventName = eventName
        self.localName = localName
        self.dateEvent = dateEvent
        self.event = event
        _selectedTheme = State(initialValue: TicketTheme(rawValue: event.ticketThemeRawValue ?? "Purple") ?? .purple)
    }

    var body: some View {
        Ticket(artistName: artistName, eventName: eventName, localName:localName, dateEvent: dateEvent, theme: selectedTheme)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in upSheet = true }
            )
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
                                        event.ticketThemeRawValue = theme.rawValue
                                        do {
                                            try context.save()
                                        } catch {
                                            upSheet = false
                                        }
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
