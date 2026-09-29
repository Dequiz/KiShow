//
//  TicketMasterShowViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//

import SwiftUI

@Observable
class TicketMasterShowViewModel{
    var concerts: [TicketmasterShow] = []

    func fetchConcert() async {
        concerts = await WebService().downloadData()
    }
    
    
}
