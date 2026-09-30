//
//  VinylRecord.swift
//  MyApp
//
//  Created by Andre on 29/09/26.
//

import SwiftUI


struct VinylRecord: View {
    @State var isTurning = false
    @State var isGoingUp = false
    let fullVynil: CGFloat
    var vynilHole: CGFloat { fullVynil * 0.3 }
    var holeBorder: CGFloat { vynilHole - 5 }
    var spacingStack: CGFloat {fullVynil * 0.4}
    var spacingNotes: CGFloat {fullVynil * 0.4}
    let noteColor = NoteColors()
    
    var body: some View {
        VStack(spacing:-spacingStack){
          
                HStack(spacing: spacingNotes){
                    Image(.notaMusical)
                        .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                        .offset(y: isGoingUp ? -20 : 0)
                        .animation(
                            isGoingUp ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                            value: isGoingUp
                        )
                        .padding(.top,200)
                    Image(.notaMusical)
                        .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                        .offset(y: isGoingUp ? -20 : 0)
                        .animation(
                            isGoingUp ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                            value: isGoingUp
                        )
                    Image(.notaMusical)
                        .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                        .offset(y: isGoingUp ? -20 : 0)
                        .animation(
                            isGoingUp ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                            value: isGoingUp
                        )
                    Image(.notaMusical)
                        .foregroundStyle(noteColor.noteColors.randomElement() ?? Color.mainPink)
                        .offset(y: isGoingUp ? -20 : 0)
                        .animation(
                            isGoingUp ? Animation.linear(duration: 2).repeatForever(autoreverses: true) : Animation.linear(duration: 0),
                            value: isGoingUp
                        )
                        .padding(.top,200)
                }
                .opacity(isGoingUp ? 1 : 0)
            

            Button {
                isTurning.toggle()
                isGoingUp.toggle()
            } label: {
                AsyncImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTB2sEEuzNGe7eJgnPZO-n4nrOQhprLT-pGjcCNnXvbSQ&s=10")) { image in
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
                
                .rotationEffect(.degrees(isTurning ? 360 : 0))
                .animation(
                    isTurning ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : Animation.linear(duration: 0),
                    value: isTurning
                )
            }
            
        }
       
        
      
        .onAppear{
            isTurning = true
            isGoingUp = true
        }
       
    }
}

#Preview {
    VinylRecord(fullVynil: 150)
}
