//
//  testView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 30/09/26.
//

import SwiftUI

struct testView: View {
    
    @State var shows = TicketMasterShowViewModel()
    
    var body: some View {
        List(shows.show){show in
            Text(show.name)
            
        }.task{
            await shows.fetchConcert()
        }
    }
}
#Preview {
    testView()
}
