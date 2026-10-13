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
    let urlMusic : URL
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
                AsyncImage(url: urlMusic) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .overlay {
                    Circle()
                        .foregroundStyle(Color.white)
                        .frame(width: vynilHole, height: vynilHole)
                        .overlay {
                            Circle()
                                .foregroundStyle(Color.black)
                                .frame(width: holeBorder, height: holeBorder)
                        }
                }
                .frame(width: fullVynil, height: fullVynil)
                .background(.black)
                .clipShape(Circle())
                
                .rotationEffect(.degrees(shouldTurn ? 360 : 0))
                .animation(
                    shouldTurn ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : Animation.linear(duration: 0),
                    value: shouldTurn
                )
            }
            
        }
       
    }
}

#Preview {
    VinylRecord(fullVynil: 200,urlMusic: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbvv14-nh3H7SOhX6F9HXdfraMR8hvFsNfVgmkM-Kasw&s=10")!)
}
