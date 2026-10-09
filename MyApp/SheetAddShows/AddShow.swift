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
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ShowEntityViewModel()
    @Query var events: [EventEntity]
    @State private var showToast = false
    @State private var calendarToastMessage = ""
    @State private var calendarToastSucceeded = false
    @State private var isAddingToCalendar = false
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
    
    //@State var vielmodel = ShowEntityViewModel()
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
                        Text(ticketMasterShow.venue?.city?.name ?? "Sem Cidade")
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
                                    calendarToastMessage = "A data deste show não está disponível."
                                    calendarToastSucceeded = false
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
                                        calendarToastMessage = "Show: \(nomeShow) foi adicionado ao calendário."
                                        calendarToastSucceeded = true
                                    case .alreadyExists:
                                        calendarToastMessage = "Show: \(nomeShow) já está no calendário."
                                        calendarToastSucceeded = false
                                    case .accessDenied:
                                        calendarToastMessage = "Sem permissão para acessar o calendário."
                                        calendarToastSucceeded = false
                                    case .failed(let message):
                                        calendarToastMessage = "Não foi possível adicionar o show: \(message)"
                                        calendarToastSucceeded = false
                                    }
                                    isAddingToCalendar = false
                                    showToast = true
                                }
                            } label: {
                                HStack{
                                    Image(systemName: "calendar")
                                    Text("Adicionar no calendário")
                                        .font(.callout)
                                        .minimumScaleFactor(0.5)
                                }
                                .clipShape(.capsule)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Color.mainPurple.opacity(0.15), in: Capsule())
                                .foregroundColor(Color.white)
                            }
                            .disabled(isAddingToCalendar)
                            
                           
                        }.padding()
                       
                        
                        if let url = URL(string: ticketMasterShow.url){
                            Link(destination: url){
                                Image(systemName: "link")
                                Text("Compre agora no site da ticket master")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                        if viewModel.contains(showTicket: ticketMasterShow, shows: events) == false{
                            ButtonComponent(buttonText: "Adicionar Show"){
                                viewModel.saveShow(showTicket: ticketMasterShow, context: context)
                                dismiss()
                            }
                        }
                        
                        
                        
                        
                    }
                }
                
                
                
            }.navigationTitle("Adicionar Shows")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarTitleDisplayMode(.automatic)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            action()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
        }
        .simpleToast(isPresented: $showToast, options: toastOption, content: {
            HStack(spacing: 10) {
                Image(systemName: calendarToastSucceeded ? "calendar.badge.checkmark" : "calendar")
                    .font(.callout)
                Text(calendarToastMessage)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .background(calendarToastSucceeded ? Color.mainPurple : Color.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .frame(maxWidth: 360)
            .padding(.horizontal, 16)
        })
        
    }
}
