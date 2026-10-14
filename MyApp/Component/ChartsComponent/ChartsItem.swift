//
//  ChartsItem.swift
//  MyApp
//
//  Created by Andre on 13/10/26.
//

import SwiftUI
struct ChartsItem: View {
    
    let share: CGFloat
    let gender: String
    let diameter: CGFloat
    
    var body: some View {
                Circle()
                    .fill(
                                   RadialGradient(
                                    colors: [.appBackground,.mainPink.opacity(0.8)],
                                    center: .center,
                                    startRadius: diameter * 0.05,
                                    endRadius: diameter * 0.5
                                   )
                               )
                    .frame(width: diameter, height: diameter)
                    .overlay{
                        VStack(spacing: 2) {
                            Text(gender)
                                .lineLimit(2)
                                .truncationMode(.tail)
                            Text("\(Int((share * 100).rounded()))%")
                                .lineLimit(1)
                        }
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                        .font(.system(size: min(15, max(8, diameter * 0.16)), weight: .bold))
                        .minimumScaleFactor(0.55)
                        .padding(diameter * 0.12)
                    }
        }
    }


#Preview {
    ChartsItem(share: 1, gender: "Rock", diameter: 80)
}
