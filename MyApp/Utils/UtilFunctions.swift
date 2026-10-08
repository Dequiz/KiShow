//
//  Date.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 06/10/26.
//

import SwiftUI


func parseDate(_ string: String?) -> Date? {
    guard let string, !string.isEmpty else { return nil }
    
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(secondsFromGMT: 0)
    
    let formats = ["yyyy-MM-dd", "dd-MM-yyyy"]
    var parsed: Date?
    for format in formats {
        f.dateFormat = format
        if let d = f.date(from: string) { parsed = d; break }
    }
    
    guard let parsed else { return nil }
    
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(secondsFromGMT: 0)!
    return cal.date(byAdding: .hour, value: 12, to: parsed) ?? parsed
}


func formattedDate(_ date: Date?) -> String {
    guard let date else { return "Sem Data" }
    let f = DateFormatter()
    f.dateFormat = "dd/MM/yyyy"
    f.timeZone = TimeZone(secondsFromGMT: 0)
    return f.string(from: date)
}


func parseTime(_ time: String)->String{
    let finalTime: String = String(time.dropLast(3))
    return finalTime
}
