//
//  Charts.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftUI
import SwiftData

struct Charts: View{
    @Query private var shows: [ShowEntity]

    private var chartsValues: [ChartItemData] {
        Array(ChartViewModel.contarTotalDeItens(shows: shows).prefix(3))
    }

    var body: some View{
        GeometryReader { geometry in
            let total = max(chartsValues.reduce(0) { $0 + $1.count }, 1)
            let positions: [CGPoint] = [
                CGPoint(x: 0.28, y: 0.38),
                CGPoint(x: 0.72, y: 0.38),
                CGPoint(x: 0.48, y: 0.70)
            ]
            let maximumDiameter = min(geometry.size.width * 0.56,
                                      geometry.size.height * 0.60)

            ZStack {
                ForEach(Array(chartsValues.enumerated()), id: \.element.id) { index, value in
                    let share = CGFloat(value.count) / CGFloat(total)
                    let diameter = max(50 , maximumDiameter * share)
                    ChartsItem(share: share, gender: value.gender, diameter: diameter)
                        .position(x: geometry.size.width * positions[index % positions.count].x,
                                  y: geometry.size.height * positions[index % positions.count].y)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 155)
    }
}
#Preview {
    Charts()
}
