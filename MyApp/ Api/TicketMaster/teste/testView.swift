//
//  testView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 30/09/26.
//

import SwiftUI

struct testView: View {
    
    @State var showsTicket = TicketMasterShowViewModel()
    
    var body: some View {
        List(showsTicket.show){show in
            Button{
                
            }label: {
                HStack{
                    Text(show.name)
                    Text("+")
                }
            }
            
        }.task{
            await showsTicket.fetchConcert()
        }
    }
}
#Preview {
    testView()
}
