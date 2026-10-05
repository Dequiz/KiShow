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
    let ticketMasterShow: TicketmasterShow
    var body: some View {
        NavigationStack{
            VStack{
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
                
                Text(ticketMasterShow.attraction?.name ?? "Desconhecido")
                    .font(.title)
                    .bold()
                Text(ticketMasterShow.name)
                    .font(.title2)
                
                Text("Informações")
                    .font(.title2)
                    .bold()
                Text("Localização")
                    .font(.body)
                    .bold()
                Text("\(ticketMasterShow.venue?.address?.line1 ?? "Sem Rua") | \(ticketMasterShow.venue?.name ?? "Sem Local")")
                Text(ticketMasterShow.venue?.city?.name ?? "Sem Cidade")
                
                Text("\(ticketMasterShow.dates?.start?.localDate ?? "Sem Data") \(ticketMasterShow.dates?.start?.localTime ?? "Sem Horário")")
                
                if let url = URL(string: ticketMasterShow.url){
                    Link("Compre agora no site da ticket master", destination: url)
                }
                
                
                Button{
                    addShowToSwiftData( ticketMasterShow)
                }label:{
                    Text("Adicionar Show")
                }
                
                    
            }.navigationTitle("Buscar Shows")
                
                
        }
    }
    
    private func addShowToSwiftData(_ show: TicketmasterShow) {
        let entity = ShowEntityViewModel.makeEntity(from: show)
        context.insert(entity)
        do {
            try context.save()
        } catch {
            print("Erro ao salvar: \(error)")
        }
    }
}


