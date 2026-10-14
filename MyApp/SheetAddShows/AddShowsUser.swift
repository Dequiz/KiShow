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
        !genderShow.isEmpty          // ⬅️ gênero agora é obrigatório
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("SheetBackground")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            ZStack {
                                if let imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.largeTitle)
                                        Text("Adicionar foto")
                                            .font(.footnote)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color(.details))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.horizontal)
                        .onChange(of: selectedPhoto) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            }
                        }

                            sectionCard(title: "Informações") {
                            labeledField("Nome do show", text: $nameShow)
                            Divider()
                            labeledField("Artista / Banda", text: $artistShow)
                            Divider()

                            HStack {
                                Text("Gênero")
                                    .foregroundStyle(.secondary)
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
                                .tint(.primary)
                            }
                        }
                        .listRowBackground(Color.details)

                        sectionCard(title: "Data e Hora") {
                            HStack {
                                Text("Data").foregroundStyle(.secondary)
                                Spacer()
                                DatePicker("", selection: $dataShow, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            Divider()
                            HStack {
                                Text("Horário").foregroundStyle(.secondary)
                                Spacer()
                                DatePicker("", selection: $startTimeShow, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                        }
                        .listRowBackground(Color.details)

                        sectionCard(title: "Local") {
                            labeledField("Nome do local", text: $localShow)
                            Divider()
                            labeledField("Endereço", text: $addressShow)
                            Divider()
                            labeledField("Cidade", text: $city)
                        }
                        .listRowBackground(Color.details)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 12)
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


    @ViewBuilder
    private func sectionCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 12) {
                content()
            }
            .padding()
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func labeledField(
        _ label: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .leading)
            TextField("", text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled()
                .foregroundStyle(Color.primary)
                .tint(.mainPink)
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
                try? await Task.sleep(nanoseconds: 2_200_000_000)
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
