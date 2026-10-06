//
//  Date.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 06/10/26.
//

import SwiftUI



func parseDate(_ string: String?) -> Date {
    guard let string else { return Date() }
    let f = DateFormatter()
    f.dateFormat = "dd-mm-yyyy"
    f.locale = Locale(identifier: "pt_BR")
    return f.date(from: string) ?? Date()
}


func parseTime(_ time: String)->String{
    let finalTime: String = String(time.dropLast(3))
    return finalTime
}
