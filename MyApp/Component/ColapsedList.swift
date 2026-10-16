//
//  ColapsedList.swift
//  MyApp
//
//  Created by Andre on 16/10/26.
//

import SwiftUI

struct ColapsedList: View {
    let eventoSelecionado: EventEntity
    @State private var isExpanded = false

    private var formattedEventTime: String {
        guard let startTime = eventoSelecionado.show?.startTimeShow,
              !startTime.isEmpty else {
            return "Sem horário"
        }
        return parseTime(startTime)
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            VStack(spacing: 8) {
                HStack {
                    Text("Informações Extras")
                        .foregroundStyle(Color.secondary)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(Color.secondary)
                }

                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack{
                            Text("Endereço:")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                            Text("\(eventoSelecionado.show?.addressShow ?? "")")
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                        }
                        HStack{
                            Text("Local:")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                            Text("\(eventoSelecionado.show?.localShow ?? "")")
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        HStack{
                            Text("Data:")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                            Text("\(formattedDate(eventoSelecionado.show?.dataShow))")
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                        }
                        HStack{
                            Text("Hora:")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                            Text("\(formattedEventTime)")
                                .foregroundStyle(Color.secondary)
                                .font(.callout)
                        }

                    }
                    .padding()
                    .frame(maxWidth: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
           
        }
    }
}

//#Preview {
//    ColapsedList()
//}
