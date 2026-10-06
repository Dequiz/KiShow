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
    f.dateFormat = "yyyy-MM-dd"
    f.locale = Locale(identifier: "en_US_POSIX")
    return f.date(from: string) ?? Date()
}


func parseTime(_ time: String)->String{
    let finalTime: String = String(time.dropLast(2))
    return finalTime
}
