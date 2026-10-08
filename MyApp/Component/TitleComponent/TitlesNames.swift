    //
    //  TitlesNames.swift
    //  MyApp
    //
    //  Created by Andre on 29/09/26.
    //

struct TitleDefinition: Identifiable {
    enum Metric {
        case shows
        case photos
        case texte
        case characters
    }

    let name: String
    let hint: String
    var metric: Metric? = nil
    var goal: Int? = nil

    var id: String { name }
}

struct TitlesNames {
    let titles: [TitleDefinition] = [
        .init(name: "Colecionador Novato", hint: "Registre 1 show", metric: .shows, goal: 1),
        .init(name: "Colecionador", hint: "Registre 5 shows", metric: .shows, goal: 5),
        .init(name: "Fotografo", hint: "Adicione 3 Fotos", metric: .photos, goal: 3),
        .init(name: "Escritor", hint: "Escreva mais de 1000 Caracteres",metric: .characters,goal: 1000),
        .init(name: "Escritor Jr", hint: "Escreva 1 Texto",metric: .texte,goal: 1),
        .init(name: "Dono", hint: "Adicione Mais de 10 Shows",metric: .shows,goal: 10),
        .init(name: "Super Mary", hint: "Título secreto"),
        .init(name: "Super Andre", hint: "Título secreto"),
        .init(name: "Super Elisa", hint: "Título secreto"),
        .init(name: "Super Paulo", hint: "Título secreto")
    ]
}
