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

    private let toastOption = SimpleToastOptions(
        alignment: .top,
        hideAfter: 2,
        backdrop: Color.black.opacity(0.2),
        animation: .default,
        modifierType: .slide
    )

    private var canSave: Bool {
        !nameShow.trimmingCharacters(in: .whitespaces).isEmpty &&
        !artistShow.trimmingCharacters(in: .whitespaces).isEmpty
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
                            .background(Color(.systemGray6))
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
                            labeledField("Gênero", text: $genderShow)
                                
                        }
                        
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

                        sectionCard(title: "Local") {
                            labeledField("Nome do local", text: $localShow)
                            Divider()
                            labeledField("Endereço", text: $addressShow)
                            Divider()
                            labeledField("Cidade", text: $city)
                        }

                        ButtonComponent(buttonText: "Adicionar Show"){
                            save()
                            dismiss()
                        }
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
        }
    }


    private func save() {
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: startTimeShow)
        let startTime = String(
            format: "%02d:%02d:00",
            timeComponents.hour ?? 0,
            timeComponents.minute ?? 0
        )


        let newShow = ShowEntity(
            nameShow: nameShow.trimmingCharacters(in: .whitespaces),
            dataShow: dataShow,
            artistShow: artistShow.trimmingCharacters(in: .whitespaces),
            genderShow: genderShow.isEmpty ? "Desconhecido" : genderShow,
            imageShow: imageData?.base64EncodedString() ?? "", // ver observação abaixo
            localShow: localShow.isEmpty ? "Desconhecido" : localShow,
            addressShow: addressShow.isEmpty ? "Desconhecido" : addressShow,
            urlShow: "",
            startTimeShow: startTime,
            city: city.isEmpty ? "Desconhecido" : city,
            latitude: 0.0,
            longitude: 0.0
        )

        context.insert(EventEntity(show: newShow))

        do {
            try context.save()
            toastMessage = "Show \"\(nameShow)\" adicionado!"
            toastSucceeded = true
            showToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                dismiss()
            }
        } catch {
            toastMessage = "Erro ao salvar: \(error.localizedDescription)"
            toastSucceeded = false
            showToast = true
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: EventEntity.self, ShowEntity.self,
        configurations: config
    )

    return AddShowsUser()
        .modelContainer(container)
}
