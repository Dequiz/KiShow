//
//  ThermsOfService.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct ThermsOfService: View {
    @State private var showExternalLinkConfirmation = false
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Leia este Contrato com atenção e assegure-se de que entende o seu conteúdo. Caso não entenda ou não aceite alguma parte deste documento, não utilize o Serviço.")
                         
                    Text("O presente Termo de Uso regulamenta o uso do KiShow, voltado ao registro e à preservação de memórias de shows. O app é destinado a iPhone e iPad (iOS) e disponibilizado gratuitamente na App Store.")
                    
                    Text("Ao continuar, você declara que leu e concorda com os Termos de Uso e que tomou ciência da Política de Privacidade. ")

                } header: {
                    VStack (alignment: .leading) {
                        Text ("Bem-Vindo(a) ao KiSHow. O objetivo deste aplicativo é possibilitar o registro e a preservação das memórias e sentimentos das experiências vividas em shows.")
                            .fontWeight(.regular)
                    
                        Spacer(minLength: 30)
                        
                        HStack{
                            TermsTopics(numberTerm: "1")
                            Text("Introdução")
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("O aplicativo é desenvolvido pela Equipe de Desenvolvimento do KiShow, sendo composto por André Holovati, Elisa Tanada Giacomini da Silva, Maria Clara Fernandes Bessa e Paulo Eduardo Barbosa da Silva")
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "2")
                        Text("Equipe")
                    }
                }
                .listRowBackground(Color.details)
                
                Section {
                    Text("KiShow é um aplicativo que possibilita ao usuário encontrar novos shows que estão para acontecer no momento de utilização. É oferecido de forma totalmente gratuita, sem necessidade de compras internas no app.")
                    
                    Text("Para exibir eventos, o KiShow consulta a Discovery API da Ticketmaster. A consulta envia o gênero escolhido e o código do país Brasil; seus dados de perfil, mídias e registros não são enviados. Como em qualquer conexão com a internet, a Ticketmaster pode receber dados técnicos da requisição, como o endereço IP, conforme a [política de privacidade da Ticketmaster](https://privacy.ticketmaster.com/privacy-policy). Ao acessar links de compra, você é direcionado a um site de terceiro, regido pelos termos dele.")
                        .tint(Color.mainPink)
                        .environment(\.openURL, OpenURLAction { _ in
                            showExternalLinkConfirmation = true
                            return .handled
                        })
                    
                    Text("O KiShow não participa da venda de ingressos, o que  torna o aplicativo totalmente gratuito e desprovido de cobranças ou vendas de produtos ou serviços. Caso haja uma modificação nessas condições o usuário será alertado com antecedência.")
                    
                    Text("Ademais, é permitido o registro e a preservação das memórias e sentimentos das experiências vividas em shows. O aplicativo permite reunir fotos, vídeos, áudios e informações sobre o evento em um único espaço, facilitando a organização, localização e revisitação dessas memórias. Sendo estes armazenados exclusivamente de forma local.")
                    
                    Text("Não nos responsabilizamos por nenhum tipo de compra de ingressos")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "3")
                        Text("Serviço")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("O KiShow não é direcionado à crianças e adolescentes, e menores de 18 anos devem usá-lo somente com supervisão e autorização prévia dos pais ou responsáveis legais. O aplicativo não exibe publicidade, não realiza perfilamento e não permite interação entre usuários.")
                    
                    Text("O usuário possui apenas uma licença limitada, não exclusiva, intransferível e revogável para uso pessoal e não comercial do software. É permitido compilar o aplicativo e utilizar o código fonte no desenvolvimento de outro software desde que não utilize as artes, a interface gráfica e nada da identidade visual do aplicativo. Fora isso é vetado a reprodução, modificação ou disponibilização do aplicativo que não seja pelo canal oficial da App Store. Qualquer outro meio de obtenção do aplicativo em outros meios constitui violação destes Termos e da legislação aplicável.")
                 
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "4")
                        Text("Quem pode utilizar")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("São vedadas:")
                    
                    BulletTopic(text: "A utilização do aplicativo para atividades ilegais.")
                    BulletTopic(text: "Toda inserção de conteúdos que apresentem conteúdos ilícitos.")
                    BulletTopic(text: "Toda inserção de conteúdos que sejam perigosos ou danosos à saúde.")
                    BulletTopic(text: "Toda inserção de conteúdos que mostre um indivíduo em situação vexatória ou que infrinja a privacidade da mesma.")
                    BulletTopic(text: "Toda inserção de conteúdos pornográficos, independente do consentimento dos envolvidos")
                    BulletTopic(text: "Toda inserção de conteúdos que infrinjam direitos autorais de terceiros.")
                 
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "5")
                        Text("Permissões e restrições")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("A Equipe de Desenvolvimento KiShow têm o direito de atualizar o aplicativo, alterar ou adicionar recursos, bem como suspender, descontinuar serviços para melhorias de segurança, desempenho ou mudança de modelo de negócios.")
                    
                    Text("Reservamo-nos o direito de atualizar os Termos de Uso através de avisos prévios no aplicativo. Retificando que não há backup nem recuperação pela equipe caso desinstale, troque de aparelho ou perca o celular - em todos esses casos as memórias poderão ser apagadas, sabendo que os backups do iOS seguem as regras da Apple. Caso o aplicativo seja descontinuado ou sofrer mudanças relevantes, avisaremos com antecedência pelo aplicativo, para que você possa salvar suas memórias fora dele, caso o aplicativo ofereça esse recurso.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "6")
                        Text("Desenvolvimento, melhorias e atualizações")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("O KiShow é fornecido da forma \"Como Está\" e \"Conforme Disponível\". A Equipe de Desenvolvimento KiShow não garante que o aplicativo funcionará sem interrupções ou livres de falhas técnicas eventuais.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "7")
                        Text("Indisponibilidade no serviço")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                
                Section {
                    Text("Todos os direitos de propriedade intelectual e comercial relativos ao aplicativo KiShow, exceto os dados da API Discovery da Ticketmaster, inclui códigos fontes, marcas, logos, ilustrações, interfaces e o próprio software, são de propriedade exclusiva da Equipe de Desenvolvimento do KiShow, composta por André Holovati, Elisa Tanada Giacomini da Silva, Maria Clara Fernandes Bessa e Paulo Eduardo Barbosa da Silva.")
                    
                    Text("Apesar de o código fonte ser de propriedade dos desenvolvedores do KiShow, ele é disponibilizado publicamente. É permitido estudar e utilizar em outros projetos, desde que não se utilize de ilustrações, interfaces gráficas, marca e nome KiShow.")
                    
                    Text("O acesso ao aplicativo não confere ao usuário quaisquer direitos a propriedade intelectual ou comercial do mesmo, Exceto pelo direito limitado, revogável e não exclusivo de uso do aplicativo em conformidade com este Termo de Uso.")
                    
                    Text("Qualquer uso indevido que infrinja a propriedade intelectual do aplicativo, estará sujeito a processo de violação de direitos autorais (Lei nº 9.610/1998) e de propriedade industrial (Lei nº 9.279/1996), sujeitando o infrator às sanções civis e criminais cabíveis.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "8")
                        Text("Propriedade Intelectual")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("Os Termos de Uso e Políticas de Privacidade do KiShow são regidos em acordo com as leis da República Federativa do Brasil. Fica eleito o foro da Comarca de São Paulo - SP, com renúncia expressa a qualquer outro, por mais privilegiado que seja, para dirimir quaisquer dúvidas ou litígios decorrentes deste contrato.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "9")
                        Text("Lei Aplicável e Foro")
                    }
                } footer: {
                    Text("Vigência a partir de 12/10/2026.")
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
            }
            .background(Color.appBackground)
            .scrollContentBackground(.hidden)
        }
        .overlay {
            PrimaryColorAlertPresenter(
                isPresented: $showExternalLinkConfirmation,
                title: "Você está saindo do KiShow",
                message: "Você será redirecionado para uma página externa com a política de privacidade.",
                confirmTitle: "Continuar",
                cancelTitle: "Cancelar",
                onConfirm: {
                    guard let url = URL(string: "https://dequiz.github.io/KiShow/index.html") else { return }
                    openURL(url)
                },
                onCancel: { }
            )
            .frame(width: 1, height: 1)
            .opacity(0.01)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
        .navigationTitle("Termos de Uso")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    ThermsOfService()
}
