//
//  AddShow.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 05/10/26.
//

import SwiftUI
import SwiftData
import SimpleToast

struct AddShow: View {
    @Environment(\.openURL) private var openURL
    @State private var showExternalLinkConfirmation = false
    @State private var pendingExternalURL: URL?
    @State private var externalLinkMessage = "Você será redirecionado para uma página externa com a política de privacidade."
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = EventEntityViewModel()
    @Query private var matchingEvents: [EventEntity]
    init(ticketMasterShow: TicketmasterShow, action: @escaping () -> Void) {
        self.ticketMasterShow = ticketMasterShow
        self.action = action

        let name = ticketMasterShow.name
        let date = parseDate(ticketMasterShow.dates?.start?.localDate) ?? .distantPast

        _matchingEvents = Query(
            filter: #Predicate<EventEntity> { event in
                event.show?.nameShow == name &&
                event.show?.dataShow == date
            }
        )
    }
    private var isAlreadyAdded: Bool { !matchingEvents.isEmpty }
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastSucceeded = false
    @State private var isAddingToCalendar = false
    @State private var isSavingShow = false
    let manager = CalendarManager()
    private let toastOption = SimpleToastOptions(alignment: .top,hideAfter: 2,backdrop: Color.black.opacity(0.2),animation: .default,modifierType: .slide)
    let ticketMasterShow: TicketmasterShow
    var action: () -> Void

    private var showStartDate: Date? {
        eventStartDate(
            localDate: ticketMasterShow.dates?.start?.localDate,
            localTime: ticketMasterShow.dates?.start?.localTime,
            timeZoneIdentifier: ticketMasterShow.venue?.timezone
        )
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("SheetBackground")
                    .ignoresSafeArea()
                VStack(spacing: 5){
                    AsyncImage(url: URL(string: ticketMasterShow.images?.max(by: { ($0.width ?? 0) < ($1.width ?? 0) })?.url ?? "Teste")){ phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Color.gray.opacity(0.2)
                        }
                    }
                    .frame(maxWidth: 368)
                    .frame(height: 220)
                    .cornerRadius(20)
                    
                    VStack{
                        Text(ticketMasterShow.attraction?.name ?? "Desconhecido")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(ticketMasterShow.name)
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    Text("Informações")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Localização", systemImage: "mappin.and.ellipse")
                            .font(.body.bold())
                        Text("\(ticketMasterShow.venue?.address?.line1 ?? "Sem Rua") | \(ticketMasterShow.venue?.name ?? "Sem Local")")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(ticketMasterShow.venue?.city?.name ?? "Sem Cidade") | \(ticketMasterShow.venue?.state?.stateCode ?? "Sem Estado")")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let latitude = ticketMasterShow.latitude,
                           let longitude = ticketMasterShow.longitude,
                           (-90.0...90.0).contains(latitude),
                           (-180.0...180.0).contains(longitude) {
                            NavigationLink {
                                MapView(
                                    latitude: latitude,
                                    longitude: longitude,
                                    placeName: ticketMasterShow.venue?.name ?? ticketMasterShow.name
                                )
                            } label: {
                                Label("Ver localização no mapa", systemImage: "map")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Color.mainPink)
                                    .foregroundColor(Color.mainPink)
                                    .tint(Color.mainPink)
                            }
                            .padding(.top, 4)
                        } else {
                            Text("Coordenadas do local não disponíveis.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    VStack{
                        HStack{
                            VStack{
                                HStack{
                                    Image(systemName: "calendar")
                                    Text("Data e Hora")
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.body)
                                .bold()
                                Text("\(formattedDate(parseDate(ticketMasterShow.dates?.start?.localDate))) às \(parseTime(ticketMasterShow.dates?.start?.localTime ?? "00:00:00"))")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                            Button {
                                guard !isAddingToCalendar else { return }
                                guard let dateShow = showStartDate else {
                                    toastMessage = "A data deste show não está disponível."
                                    toastSucceeded = false
                                    showToast = true
                                    return
                                }
                                let nomeShow = ticketMasterShow.name
                                let title = "Show do: \(nomeShow)"
                                isAddingToCalendar = true
                                Task {
                                    let result = await manager.criarCompromisso(
                                        titulo: title,
                                        dataInicio: dateShow,
                                        dataFim: dateShow,
                                        timeZone: ticketMasterShow.venue?.timezone.flatMap(TimeZone.init(identifier:))
                                    )
                                    switch result {
                                    case .added:
                                        toastMessage = "Show: \(nomeShow) foi adicionado ao calendário."
                                        toastSucceeded = true
                                    case .alreadyExists:
                                        toastMessage = "Show: \(nomeShow) já está no calendário."
                                        toastSucceeded = false
                                    case .accessDenied:
                                        toastMessage = "Sem permissão para acessar o calendário."
                                        toastSucceeded = false
                                    case .failed(let message):
                                        toastMessage = "Não foi possível adicionar o show: \(message)"
                                        toastSucceeded = false
                                    }
                                    isAddingToCalendar = false
                                    showToast = true
                                }
                            } label: {
                                HStack{
                                    Image(systemName: "calendar")
                                    Text("Adicionar no calendário")
                                        .font(.callout)
                                        .minimumScaleFactor(0.7)
                                        .lineLimit(1)
                                }
                                .clipShape(.capsule)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.mainPurple.opacity(0.5), in: Capsule())
                                .foregroundColor(Color.white)
                            }
                            .disabled(isAddingToCalendar)
                            
                           
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                       
                        
                        if let url = URL(string: ticketMasterShow.url){
                            Button {
                                pendingExternalURL = url
                                externalLinkMessage = "Você será redirecionado para uma página externa com a política de privacidade."
                                showExternalLinkConfirmation = true
                            } label: {
                                Image(systemName: "link")
                                Text("Compre agora no site da ticket master")
                            }
                            .foregroundStyle(Color.mainPink)
                            .tint(Color.mainPink)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        }
         
                    }
                }
                
                
                
            }.navigationTitle("Adicionar Shows")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarTitleDisplayMode(.automatic)
                .toolbar{
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            action()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .tint(.primary)
                    }
                    
                    ToolbarItem(placement: .confirmationAction){
                        if !isAlreadyAdded{
                            Button("", systemImage: "checkmark"){
                                guard !isSavingShow else { return }
                                isSavingShow = true
                                Task {
                                    do {
                                        try await viewModel.saveShow(showTicket: ticketMasterShow, context: context)
                                        let artist = ticketMasterShow.attraction?.name ?? "Desconhecido"
                                        toastMessage = "Show de: \(artist) foi adicionado com sucesso."
                                        toastSucceeded = true
                                        showToast = true
                                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                                        action()
                                        dismiss()
                                    } catch {
                                        isSavingShow = false
                                        toastMessage = "Não foi possível adicionar o show de: \(ticketMasterShow.attraction?.name ?? "Desconhecido"). \(error.localizedDescription)"
                                        toastSucceeded = false
                                        showToast = true
                                    }
                                }
                            }
                            .tint(.mainPink)
                            .disabled(isSavingShow)
                        }
                    }
                }
        }
        .overlay {
            PrimaryColorAlertPresenter(
                isPresented: $showExternalLinkConfirmation,
                title: "Você está saindo do KiShow",
                message: externalLinkMessage,
                confirmTitle: "Continuar",
                cancelTitle: "Cancelar",
                onConfirm: {
                    guard let url = pendingExternalURL else { return }
                    openURL(url)
                    pendingExternalURL = nil
                },
                onCancel: {
                    pendingExternalURL = nil
                }
            )
            .frame(width: 1, height: 1)
            .opacity(0.01)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
        .simpleToast(isPresented: $showToast, options: toastOption, content: {
            HStack(spacing: 10) {
                Image(systemName: toastSucceeded ? "checkmark.circle" : "exclamationmark.triangle")
                    .font(.callout)
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
        })
       
        
    }
}


