import Foundation
import EventKit

enum CalendarEventResult {
    case added
    case alreadyExists
    case accessDenied
    case failed(String)
}

final class CalendarManager {
    private let eventStore = EKEventStore()

    func criarCompromisso(
        titulo: String,
        dataInicio: Date,
        dataFim: Date,
        notas: String? = nil
    ) async -> CalendarEventResult {
        do {
            let accessGranted = try await eventStore.requestFullAccessToEvents()
            guard accessGranted else { return .accessDenied }

            if eventoJaExiste(titulo: titulo, data: dataInicio) {
                return .alreadyExists
            }

            let event = EKEvent(eventStore: eventStore)
            event.title = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
            event.startDate = dataInicio
            event.endDate = dataFim > dataInicio
                ? dataFim
                : dataInicio.addingTimeInterval(60 * 60)
            event.notes = notas
            event.calendar = eventStore.defaultCalendarForNewEvents

            try eventStore.save(event, span: .thisEvent)
            return .added
        } catch {
            return .failed(error.localizedDescription)
        }
    }

    private func eventoJaExiste(titulo: String, data: Date) -> Bool {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: data)
        guard let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) else {
            return false
        }

        let predicate = eventStore.predicateForEvents(
            withStart: dayStart,
            end: dayEnd,
            calendars: nil
        )
        let expectedTitle = normalizar(titulo)
        var possibleTitles: Set<String> = [expectedTitle]
        let showPrefix = normalizar("Show do:") + " "
        if expectedTitle.hasPrefix(showPrefix) {
            possibleTitles.insert(String(expectedTitle.dropFirst(showPrefix.count)))
        } else {
            possibleTitles.insert(showPrefix + expectedTitle)
        }
        return eventStore.events(matching: predicate).contains { event in
            possibleTitles.contains(normalizar(event.title ?? ""))
        }
    }

    private func normalizar(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    }
}
