//
//  AddShowsUser.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 13/10/26.
//
import SwiftUI
import SwiftData
import PhotosUI
import SimpleToast

struct AddShowsUser: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var genreSource = TicketMasterShowViewModel()
    @State private var viewModel = EventEntityViewModel()

    @State private var nameShow: String = ""
    @State private var artistShow: String = ""
    @State private var genderShow: String = ""
    @State private var localShow: String = ""
    @State private var addressShow: String = ""
    @State private var city: String = ""
    @State private var dataShow: Date = .now
    @State private var startTimeShow: Date = .now

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastSucceeded = false
    @State private var isSavingShow = false

    private let toastOption = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    private var canSave: Bool {
        !nameShow.trimmingCharacters(in: .whitespaces).isEmpty &&
        !artistShow.trimmingCharacters(in: .whitespaces).isEmpty &&
        !genderShow.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Form {
                        Section {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                ZStack {
                                    if let imageData, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.largeTitle)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .background(Color.details)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .tint(.mainPurple)
                            
                            .onChange(of: selectedPhoto) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        imageData = data
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        VStack{
                            Text("(*) Campo obrigatório")
                                .foregroundStyle(.red)
                        }.listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                        Section(header: Text("Informações")) {
                            HStack (spacing: 20){
                                HStack(spacing: 2){
                                    Text("Nome do show")
                                    Text("*")
                                        .foregroundStyle(.red)
                                }
                                TextField("Insira o nome do show", text: $nameShow)
                            }
                            
                            HStack (spacing: 20){
                                HStack(spacing: 2){
                                    Text("Artista / Banda")
                                    Text("*")
                                        .foregroundStyle(.red)
                                }
                                TextField("Insira o artista ou banda", text: $artistShow)
                            }
                            
                            HStack {
                                HStack(spacing: 2){
                                    Text("Gênero")
                                        
                                    Text("*")
                                        .foregroundStyle(.red)
                                }.foregroundStyle(.primary)
                                    .frame(width: 120, alignment: .leading)

                                Picker("", selection: $genderShow) {
                                    Text("Selecione").tag("")
                                    ForEach(genreSource.genres, id: \.self) { genre in
                                        Text(genreSource.genresTranslations[genre] ?? genre)
                                            .tag(genre)
                                    }
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .tint(.secondary)
                            }
                        }
                        .listRowBackground(Color.details)

                        Section(header: Text("Data e Hora")) {
                            HStack {
                                Text("Data").foregroundStyle(.primary)
                                Spacer()
                                DatePicker("", selection: $dataShow, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            HStack {
                                Text("Horário").foregroundStyle(.primary)
                                Spacer()
                                DatePicker("", selection: $startTimeShow, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                        }
                        .listRowBackground(Color.details)

                        Section(header: Text("Local")) {
                            HStack (spacing: 20){
                                Text("Nome do local")
                                TextField("Insira o nome do local", text: $localShow)
                            }
                            HStack (spacing: 20){
                                Text("Endereço")
                                TextField("Insira o endereço do show", text: $addressShow)
                            }
                            HStack (spacing: 20){
                                Text("Cidade")
                                TextField("Insira a cidade do show", text: $city)
                            }
                        }
                        .listRowBackground(Color.details)
                        
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Novo Show")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        save()
                    }label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(!canSave || isSavingShow)
                }
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOption) {
            HStack(spacing: 10) {
                Image(systemName: toastSucceeded ? "checkmark.circle" : "exclamationmark.triangle")
                Text(toastMessage)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .background(toastSucceeded ? Color.mainPurple : Color.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .frame(maxWidth: 360)
            .padding(.horizontal, 16)
        }
    }

    private func save() {
        guard canSave, !isSavingShow else { return }
        isSavingShow = true

        do {
            try viewModel.saveCustomShow(
                nameShow: nameShow,
                dataShow: dataShow,
                artistShow: artistShow,
                genderShow: genderShow,
                imageData: imageData,
                localShow: localShow,
                addressShow: addressShow,
                urlShow: "",
                startTime: startTimeShow,
                city: city,
                latitude: nil,
                longitude: nil,
                context: context
            )

            toastMessage = "Show de: \(artistShow) foi adicionado com sucesso."
            toastSucceeded = true
            showToast = true
            Task {
                try? await Task.sleep(nanoseconds: 1_200_000_000)
                dismiss()
            }
        } catch {
            isSavingShow = false
            toastMessage = "Não foi possível adicionar o show de: \(artistShow). \(error.localizedDescription)"
            toastSucceeded = false
            showToast = true
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    do {
        let container = try ModelContainer(
            for: EventEntity.self, ShowEntity.self,
            configurations: config
        )
        return AnyView(AddShowsUser().modelContainer(container))
    } catch {
        return AnyView(Text("Não foi possível carregar a prévia."))
    }
}
