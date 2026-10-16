//
//  VinylRecord.swift
//  MyApp
//
//  Created by Andre on 29/09/26.
//

import SwiftUI


struct VinylRecord: View {
    var isTurning = false
    var isGoingUp = false
    @State private var userIsTurning = false
    @State private var userIsGoingUp = false
    let fullVynil: CGFloat
    let image: Image?
    var vynilHole: CGFloat { fullVynil * 0.3 }
    var holeBorder: CGFloat { vynilHole - 5 }
    var spacingStack: CGFloat {fullVynil * 0.4}
    var spacingNotes: CGFloat {fullVynil * 0.4}
    private var shouldTurn: Bool { isTurning || userIsTurning }
    private var shouldRaiseNotes: Bool { isGoingUp || shouldTurn || userIsGoingUp }
    let noteColor = NoteColors()
    var body: some View {
        VStack(spacing:-spacingStack){
            HStack(spacing: spacingNotes){
                Image(.notaMusical)
                    .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                    .offset(y: shouldRaiseNotes ? -20 : 0)
                    .animation(
                        shouldRaiseNotes ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                        value: shouldRaiseNotes
                    )
                    .padding(.top,200)
                Image(.notaMusical)
                    .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                    .offset(y: shouldRaiseNotes ? -20 : 0)
                    .animation(
                        shouldRaiseNotes ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                        value: shouldRaiseNotes
                    )
                Image(.notaMusical)
                    .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                    .offset(y: shouldRaiseNotes ? -20 : 0)
                    .animation(
                        shouldRaiseNotes ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                        value: shouldRaiseNotes
                    )
                Image(.notaMusical)
                    .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                    .offset(y: shouldRaiseNotes ? -20 : 0)
                    .animation(
                        shouldRaiseNotes ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                        value: shouldRaiseNotes
                    )
                    .padding(.top,200)
            }
            .opacity(shouldRaiseNotes ? 1 : 0)
            
            Button {
                userIsTurning.toggle()
                userIsGoingUp.toggle()
            } label: {
                ZStack {
                    Circle()
                        .stroke()
                        .tint(.gray)                        .frame(width: fullVynil*0.9,height: fullVynil*0.9)
                    Circle()
                        .stroke()
                        .tint(.gray)                        .frame(width: fullVynil*0.8,height: fullVynil*0.8)
                    Circle()
                        .stroke()
                        .tint(.gray)                        .frame(width: fullVynil*0.7,height: fullVynil*0.7)
                                    if let image {
                                        image
                                            .resizable()
                                            .frame(width: fullVynil * 0.5,height: fullVynil * 0.5)
                                            .scaledToFill()
                                            .background(.appBackground)
                                            .clipShape(.circle)

                                    } else {
                                        Color.gray
                                    }
                        }
                }
                .frame(width: fullVynil, height: fullVynil)
                .background(.black)
                .clipShape(.circle)
                .rotationEffect(.degrees(shouldTurn ? 360 : 0))
                .animation(
                    shouldTurn
                    ? .linear(duration: 2).repeatForever(autoreverses: false)
                    : .linear(duration: 0.3),
                    value: shouldTurn
                )
            }
        }
        
    }

#Preview {
    VinylRecord(fullVynil: 150, image: Image("ArtGroup"))
}
