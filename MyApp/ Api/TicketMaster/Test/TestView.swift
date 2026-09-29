//
//  TestView.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//

import SwiftUI

struct TestView: View {
    @State private var ticketMasterShowViewModel = TicketMasterShowViewModel()

    var body: some View {
        List(ticketMasterShowViewModel.concerts) { concert in
            VStack(alignment: .leading, spacing: 6) {
                Text(concert.name)
                    .font(.headline)

                Text(concert.url)
                    .font(.subheadline)
            }
        }
        .task {
            await ticketMasterShowViewModel.fetchConcert()
        }
    }
}

#Preview {
    TestView()
}
