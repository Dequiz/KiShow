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
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)

    for format in ["HH:mm:ss", "HH:mm"] {
        formatter.dateFormat = format
        if let date = formatter.date(from: time) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
    }

    return time
}

/// Combines Ticketmaster's venue-local date and time into an absolute Date.
func eventStartDate(
    localDate: String?,
    localTime: String?,
    timeZoneIdentifier: String?
) -> Date? {
    guard let localDate, !localDate.isEmpty else { return nil }

    let timeZone = timeZoneIdentifier.flatMap(TimeZone.init(identifier:)) ?? .current
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.timeZone = timeZone

    let time = localTime.flatMap { $0.isEmpty ? nil : $0 } ?? "00:00:00"
    for format in ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "dd-MM-yyyy HH:mm:ss", "dd-MM-yyyy HH:mm"] {
        formatter.dateFormat = format
        if let date = formatter.date(from: "\(localDate) \(time)") {
            return date
        }
    }

    for format in ["yyyy-MM-dd", "dd-MM-yyyy"] {
        formatter.dateFormat = format
        if let date = formatter.date(from: localDate) {
            return date
        }
    }
    return nil
}
