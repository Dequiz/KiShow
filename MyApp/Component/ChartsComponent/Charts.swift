//
//  Charts.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftUI
import SwiftData

struct Charts: View{
    @Environment(\.modelContext) var context
    @State var viewModel = ChartViewModel()
    @State var chartsValues = [ChartItemData]().prefix(3)
    var body: some View{
        GeometryReader { geometry in
            let total = max(chartsValues.reduce(0) { $0 + $1.count }, 1)
            let positions: [CGPoint] = [
                CGPoint(x: 0.25, y: 0.35),
                CGPoint(x: 0.69, y: 0.29),
                CGPoint(x: 0.48, y: 0.73)
            ]
            ZStack {
                ForEach(Array(chartsValues.enumerated()), id: \.element.id) { index, value in
                    let share = CGFloat(value.count) / CGFloat(total)
                    let maximumDiameter = min(geometry.size.width * 0.43,
                                              geometry.size.height * 0.72)
                    let diameter = maximumDiameter * share
                    ChartsItem(share: share, gender: value.gender, diameter: diameter)
                        .position(x: geometry.size.width * positions[index % positions.count].x,
                                  y: geometry.size.height * positions[index % positions.count].y)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .task {
            chartsValues = viewModel.contarTotalDeItens(context: context).prefix(3)
        }
    }
}
#Preview {
    Charts()
}
