//
//  SheetEditPerfil.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 01/10/26.
//
import SwiftUI
import SwiftData


struct EditPerfil: View {
    enum Field {
        case name
    }
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \UserEntity.idUser) var users: [UserEntity]
    var userSelected: UserEntity? {
        users.first
    }
    @FocusState private var focusedField: Field?
    @State var segmented = 0
    @State var changeName: String = ""
    @State var newPhotoSelected: Data? = nil
    @State private var photoSelection: ProfilePhotoSelection?
  

   
var body: some View {
    NavigationStack {
        ZStack {
            Color("SheetBackground")
                .ignoresSafeArea()
    
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Edite seu Nome")
                    
                    TextField(userSelected?.nameUser ?? "Edite seu Nome", text: $changeName)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .padding(.horizontal,20)
                        .background(Color.detailsSheet)
                        .foregroundStyle(Color.primary)
                        .tint(.mainPink)
                        .clipShape(.capsule)
                        .focused($focusedField, equals: .name)
                    Text("Edite sua foto")
                    
                    Picker("", selection: $segmented) {
                        Text("Galeria").tag(0)
                        Text("Ilustração").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    if segmented == 0 {
                        HStack {
                            Spacer()
                            InsertFromGallery(selection: $photoSelection)
                            Spacer()
                        }
                    } else {
                            InsertCategoryIlustrations(categoryNames: CategoryNames(), selection: $photoSelection)
                    }
                    
                    Spacer()
                }
                .padding(20)
                .navigationTitle("Editar Perfil")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                   ToolbarItem(placement: .cancellationAction) {
                       Button("", systemImage: "xmark") {
                           dismiss()
                       }
                       .accessibilityLabel("Cancelar edição do perfil")
                       .tint(.primary)
                   }
                   ToolbarItem(placement: .confirmationAction) {
                       Button("", systemImage: "checkmark") {
                           if let user = userSelected {
                             
                               //NOME
                               if !changeName.isEmpty {
                                   user.nameUser = changeName
                               }
                               
                               photoSelection?.apply(to: user)
                           }
                           dismiss()
                       }
                       .tint(.mainPink)
                       .accessibilityLabel("Salvar alterações do perfil")
                       }
                    
                   }
               }.onTapGesture {
                   focusedField = nil
               }
               .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    EditPerfil(changeName: "Test")
}
