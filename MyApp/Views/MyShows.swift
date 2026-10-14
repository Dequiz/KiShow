//
//  MyShows.swift
//  MyApp
//
//  Created by Andre on 28/09/26.
//

import SwiftUI
import SwiftData
import SimpleToast

struct MyShows: View {
    @Query var events: [EventEntity]
    @Query var experiencies: [ExperienceEntity]
    @State private var dm = TitleDefinitionMachine()
    @Environment(\.modelContext) var context
    
    var eventosFiltrados: [EventEntity] {
        let calendar = Calendar.current
        let hoje = calendar.startOfDay(for: Date())
        
        let porPeriodo: [EventEntity]
        switch selectPeriod {
        case "Próximos":
            porPeriodo = events.filter {
                guard let data = $0.show?.dataShow else { return false }
                return calendar.startOfDay(for: data) >= hoje
            }
        case "Encerrados":
            porPeriodo = events.filter {
                guard let data = $0.show?.dataShow else { return false }
                return calendar.startOfDay(for: data) < hoje
            }
        default:
            porPeriodo = events
        }
        
        guard !searchText.isEmpty else { return porPeriodo }
        
        let termo = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
        
        return porPeriodo.filter { event in
            let artista = event.show?.artistShow ?? ""
            let nome = event.show?.nameShow ?? ""
            let local = event.show?.localShow ?? ""
            let cidade = event.show?.city ?? ""
            
            return [artista, nome, local, cidade].contains { campo in
                campo
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .lowercased()
                    .contains(termo)
            }
        }
    }
    
    @State var selectPeriod: String = "Todos"
    @State var searchText: String = ""
    @State var isAddShow: Bool = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastSucceeded = false

    private let toastOption = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    private var totalPhotos: Int {
        experiencies.reduce(0) { $0 + ($1.imageContent?.count ?? 0) }
    }

    private var totalTexts: Int {
        experiencies.reduce(0) { $0 + ($1.textContent?.count ?? 0) }
    }

    private var totalTextCharacters: Int {
        experiencies.reduce(0) { total, experience in
            total + (experience.textContent ?? []).reduce(0) { $0 + $1.count }
        }
    }

    private var achievementRefreshKey: String {
        "\(events.count)-\(totalPhotos)-\(totalTexts)-\(totalTextCharacters)"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("AppBackground")
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    Image(.camada1)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth:.infinity)
                        .frame(maxHeight: 200)
                        .opacity(0.3)

                }
                .ignoresSafeArea()
                    
                    
                if eventosFiltrados.isEmpty{
                    VStack{
                        Image(.eletronic)
                            .resizable()
                            .frame(maxWidth: 263)
                            .frame(height: 279)
                        Text("Você ainda não possui nenhum show")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    
                    }
                }else{
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(eventosFiltrados) { event in
                                NavigationLink {
                                    EventView(eventoSelecionado: event)
                                } label: {
                                    TicketSelection(
                                        artistName: event.show?.artistShow ?? "Artista",
                                        eventName: event.show?.nameShow ?? "Evento",
                                        localName: event.show?.localShow ?? "Local",
                                        dateEvent: event.show?.dataShow ?? Date(),
                                        event: event
                                    ).padding()
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                deleteShow(event)
                                            } label: {
                                                Label("Excluir", systemImage: "trash")
                                            }
                                        
                                    }
                                    
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                
            }
                .simpleToast(isPresented: $showToast, options: toastOption) {
                    HStack(spacing: 10) {
                        Image(systemName: toastSucceeded ? "checkmark.circle" : "exclamationmark.triangle")
                        Text(toastMessage)
                            .font(.callout)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .background(toastSucceeded ? Color.mainPurple : Color.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .frame(maxWidth: 360)
                    .padding(.horizontal, 16)
                }
                .navigationTitle("Meus Shows")
                .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Pesquise pelo seu show"
                    )
                .toolbarTitleDisplayMode(.inlineLarge)
                .sheet(isPresented: $isAddShow){
                    AddShowsUser()
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            isAddShow.toggle()
                        }label:{
                            Image(systemName: "plus")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu{
                            Button{
                                selectPeriod = "Todos"
                            }label: {
                                HStack{
                                    Text("Todos")
                                    if selectPeriod == "Todos"{
                                        Image(systemName: "checkmark.circle")
                                    }
                                    
                                }
                            }
                            Button{
                                selectPeriod = "Próximos"
                            }label: {
                                HStack{
                                    Text("Próximos")
                                    if selectPeriod == "Próximos"{
                                        Image(systemName: "checkmark.circle")
                                    }
                                }
                            }
                            Button{
                                selectPeriod = "Encerrados"
                            }label: {
                                HStack{
                                    Text("Encerrados")
                                    if selectPeriod == "Encerrados"{
                                        Image(systemName: "checkmark.circle")
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease")
                        }
                    }
                }
                .foregroundStyle(.primary)
                
        }
        
        .task(id: "\(achievementRefreshKey)-\(isAddShow)") {
            guard !isAddShow else { return }
            let actions: [TitleDefinitionMachine.UserAction] = [
                .showRegistered(totalShows: events.count),
                .photosAdded(totalPhotos: totalPhotos),
                .textAdded(totalText: totalTexts),
                .textAdded(totalText: totalTextCharacters)
            ]
            var unlocked: [String] = []
            var errors: [Error] = []
            for action in actions {
                do {
                    unlocked += try dm.processAction(action, context: context)
                } catch {
                    errors.append(error)
                }
            }

            if !unlocked.isEmpty {
                let title = unlocked.count == 1 ? "Conquista desbloqueada" : "Conquistas desbloqueadas"
                toastMessage = "\(title): \(unlocked.joined(separator: ", "))."
                toastSucceeded = true
                showToast = true
            } else if let error = errors.first {
                toastMessage = "Não foi possível desbloquear a conquista. \(error.localizedDescription)"
                toastSucceeded = false
                showToast = true
            }
        }

    }

    private func deleteShow(_ event: EventEntity) {
        let showName = event.show?.nameShow ?? "Show"
        context.delete(event)
        do {
            try context.save()
            toastMessage = "Show: \(showName) foi excluído com sucesso."
            toastSucceeded = true
        } catch {
            context.rollback()
            toastMessage = "Não foi possível excluir o show: \(showName). \(error.localizedDescription)"
            toastSucceeded = false
        }
        showToast = true
    }
}


