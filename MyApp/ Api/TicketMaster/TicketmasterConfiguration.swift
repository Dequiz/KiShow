internal import Foundation

enum TicketmasterConfiguration {
    static var apiKey: String {
        let value = Bundle.main.object(forInfoDictionaryKey: "TicketMasterAPIKey") as? String ?? ""
        return value.hasPrefix("$(") ? "" : value
    }
}
