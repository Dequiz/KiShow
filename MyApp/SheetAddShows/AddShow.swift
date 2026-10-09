//
//  AddShow.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 05/10/26.
//

import SwiftUI
import SwiftData

struct AddShow: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ShowEntityViewModel()
    @Query var events: [EventEntity]
    let ticketMasterShow: TicketmasterShow
    var action: () -> Void
    
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
                    
                    VStack{
                        HStack{
                            Image(systemName: "mappin.and.ellipse")
                            Text("Localização")
                                
                        }.font(.body)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(ticketMasterShow.venue?.address?.line1 ?? "Sem Rua") | \(ticketMasterShow.venue?.name ?? "Sem Local")")
                            .underline()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(ticketMasterShow.venue?.city?.name ?? "Sem Cidade")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    VStack{
                        HStack{
                            Image(systemName: "calendar")
                            Text("Data e Hora")
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body)
                        .bold()

                        Text("\(formattedDate(parseDate(ticketMasterShow.dates?.start?.localDate))) às \(parseTime(ticketMasterShow.dates?.start?.localTime ?? "00:00:00"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
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
    
}


