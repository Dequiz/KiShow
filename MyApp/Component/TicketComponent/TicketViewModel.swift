//
//  TicketViewModel.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 29/09/26.
//

import SwiftUI

enum TicketTheme: String, CaseIterable, Identifiable{
case purple = "Purple"
case blue = "Blue"
case pink = "Pink"
case green = "Green"
    
var id: String {rawValue}

var background: String {
    "\(rawValue)Background"
}

var principalArea: String {
    "\(rawValue)PrincipalArea"
}

var secondaryArea: String {
    "\(rawValue)SecondaryArea"
}
    
var Text: String {
    "\(rawValue)Text"
}
    
var imageName: String {
"\(rawValue)Ticket"
}
}
