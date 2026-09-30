//
//  Ticket.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 29/09/26.
//
import SwiftUI

struct Ticket: View {
    var ticketType: String = "BlueTicket"
    var artistName: String = "Laufey"
    var eventName: String = "A Matter of Time Tour"
    var localName: String = "Espaço Unimed"
    var dateEvent: String = "16-06-2023"
    
    var theme: TicketTheme = .purple
    
    let baseWidth: CGFloat = 350.0

    var body: some View {
        GeometryReader { geometry in
            
            let scale = geometry.size.width / baseWidth
            
            ZStack {
                Image(theme.background)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        HStack(spacing: 15 * scale) {
                           
                            Image(theme.secondaryArea)
                                .resizable()
                                .scaledToFit()
                                .overlay(
                                    VStack(spacing: 15 * scale) {
                                        Text(localName)
                                            .font(.system(size: 12 * scale, weight: .regular))
                                            .foregroundColor(Color(theme.Text))
                                            .padding(.top, 30 * scale)
                                        
                                        Text(dateEvent)
                                            .font(.system(size: 12 * scale, weight: .regular))
                                            .foregroundColor(Color(theme.Text))
                                    }
                                    .padding(.horizontal, 5)
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                )
                            
                            Image(theme.principalArea)
                                .resizable()
                                .scaledToFit()
                                .overlay(
                                    VStack(spacing: 8 * scale) {
                                        Text(artistName)
                                            .font(.custom("Gramers Semi Bold", size: 30 * scale))
                                            .padding(.top, 20 * scale)
                                            .foregroundColor(Color(theme.Text))
                                        
                                        Text(eventName)
                                            .font(.system(size: 16 * scale, weight: .thin))
                                            .foregroundColor(Color(theme.Text))
                                    }
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                )
                        }
                        .padding(10 * scale)
                    )
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .aspectRatio(2.2, contentMode: .fit)
        .padding()
    }
}

#Preview {
    Ticket()
}
