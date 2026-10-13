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
                        Text("\(gender)\n\(Int((share * 100).rounded()))%")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.white)
                            .font(.system(size: min(16, max(10, diameter * 0.13))))
                            .fontWeight(.bold)
                    }
        }
    }


#Preview {
    ChartsItem(share: 1, gender: "Rock", diameter: 80)
}
