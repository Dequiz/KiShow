//
//  ShowEntityViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//

import Foundation
import SwiftUI


@Observable
class ShowEntityViewModel{
    var show: [ShowEntity]
    private var showTicketmaster: TicketMasterShowViewModel
    
    init(show: [ShowEntity], showTicketmaster: TicketMasterShowViewModel) {
        self.show = show
        
    }
    
}
