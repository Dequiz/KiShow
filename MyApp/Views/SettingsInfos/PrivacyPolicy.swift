//
//  PrivacyPolicy.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct PrivacyPolicy: View {
    @Environment(\.openURL) private var openURL
    @State private var showExternalLinkConfirmation = false
    @State private var pendingExternalURL: URL?
    @State private var externalLinkMessage = "Você será redirecionado para uma página externa com a política de privacidade."

    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Esta Política de Privacidade descreve nossas políticas e procedimentos relativos à coleta, uso e divulgação de suas informações quando você utiliza o Serviço, além de informar sobre seus direitos de privacidade e como a lei o protege.")

                    Text("Utilizamos seus Dados Pessoais para fornecer e aprimorar o Serviço. Coletamos e usamos suas informações conforme descrito nesta Política de Privacidade e quando exigido pela legislação aplicável. Neste último caso, seu consentimento deve e será considerado.")


                    Text("Dessa forma, a Equipe de Desenvolvimento KiShow, composta pelos integrantes: André Holovati, Elisa Tanada Giacomini da Silva, Maria Clara Fernandes Bessa e Paulo Eduardo Barbosa da Silva, se responsabiliza pelo cumprimento dos termos criados.")

                } header: {
                    VStack (alignment: .leading) {
                        Text ("Última atualização: 19 de outubro de 2026")
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
                    BulletTopic(text: "Nome de exibição;")
                    BulletTopic(text: "Fotos e vídeos escolhidos pelo usuário;")
                    BulletTopic(text: "Áudios e textos adicionados às experiências de shows;")
                    BulletTopic(text: "Dados dos shows registrados pelo usuário.")

                } header: {
                    HStack{
                        TermsTopics(numberTerm: "2")
                        Text("Dados coletados pelo app")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section {
                    Text("**Perfil:** O cadastro atual solicita um nome de exibição, armazenado localmente.")

                    Text("**Fotos e vídeos:** Para anexar uma foto ou vídeo, o app usa o seletor de mídia do iOS. Você escolhe quais itens compartilhar com o app; ele não solicita acesso geral à fototeca nem usa a câmera.")

                    Text("**Áudios:** O microfone só é solicitado quando você inicia uma gravação de áudio para uma experiência.")

                    Text("**Calendário:** Ao tocar em adicionar show ao calendário, o app solicita acesso ao Calendário para verificar se já existe um evento semelhante e, se você autorizar, adicionar o show. O conteúdo dos demais eventos não é salvo pelo KiShow nem enviado aos nossos servidores.")

                    Text("**Consulta de eventos:** O app envia à Discovery API da Ticketmaster o gênero escolhido e o código do país Brasil para buscar eventos. A Ticketmaster também recebe dados técnicos da conexão, como o endereço IP. Nome, mídias e registros pessoais não são incluídos na consulta.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "3")
                        Text("Finalidade da coleta de dados")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section{
                    Text("Todas as imagens, vídeos e áudios inseridos no aplicativo são processados e armazenados exclusivamente de forma local no dispositivo do usuário. O aplicativo não realiza upload, não armazena cópias em servidores externos e não tem acesso remoto a esses arquivos.")

                } header: {
                    HStack{
                        TermsTopics(numberTerm: "4")
                        Text(" Armazenamento e Privacidade das Mídias")
                    }
                }.listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section{
                    Text("Os dados inseridos pelo usuário nos registros de shows são armazenados localmente no dispositivo. O aplicativo não realiza upload, não armazena cópias em servidores externos e não tem acesso remoto a esses arquivos.")
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "5")
                        Text("Compartilhamento de dados")
                    }
                }.listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section {
                    Text("A proteção dos dados é estritamente feita a partir da segurança local do dispositivo, não possuindo servidores e atores externos dentro do aplicativo.")

                    Text("**Adendo importante:** apesar da adoção de medidas de segurança, nenhum sistema ou dispositivo pode garantir segurança absoluta contra todos os riscos existentes.")

                    Text("O KiShow trata dados pessoais apenas nas hipóteses previstas no art. 7º da LGPD (Lei nº 13.709/2018).")

                    Text("Todos os dados citados acima ficam armazenados somente no seu dispositivo. A equipe do KiShow não os recebe, não tem acesso remoto a eles e não os utiliza para outras finalidades. O KiShow não utiliza ferramentas de análise de uso (analytics), relatórios de falhas (crash reports) ou publicidade.")
                    Text("**Retenção:** os dados permanecem no dispositivo enquanto o aplicativo estiver instalado ou até que você os apague. Como não há cópias em servidores, a desinstalação, a troca de aparelho ou a perda do celular pode resultar na perda definitiva das informações. Backups do sistema operacional são geridos pela Apple.")
                    Text("**Dados técnicos na consulta de eventos:** ao consultar a API da Ticketmaster, ela pode receber dados técnicos da conexão (como o endereço IP). A Ticketmaster atua como responsável pelo tratamento desses dados, conforme a política de privacidade dela.")

                } header: {
                    HStack{
                        TermsTopics(numberTerm: "6")
                        Text("Proteção dos dados e segurança")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section {
                    Text("Como o aplicativo opera de forma estritamente local e os desenvolvedores não possuem acesso ou controle remoto sobre as informações (fotos, vídeos, áudios, textos), o exercício dos seus direitos de privacidade é feito diretamente por você, através da interface do aplicativo.")
                    Text("O usuário possui total direito e controle para gerenciar suas informações a qualquer momento, incluindo:")

                    Text("**Edição e Atualização:** Adicionar, alterar ou corrigir os dados de perfil e os detalhes dos registros de shows.")
                    Text("**Exclusão Parcial:** Apagar individualmente registros de shows, fotos, vídeos ou áudios específicos dentro do aplicativo.")
                    Text("**Exclusão Total e Definitiva:** O usuário pode apagar a totalidade dos dados coletados pelo aplicativo e armazenados localmente no seu aparelho simplesmente desinstalando o aplicativo do dispositivo (ou limpando os dados na aba de configurações do sistema operacional).")

                    Text("Em caso de dúvidas ou solicitações relacionadas ao tratamento de dados pessoais eventualmente realizado pela equipe responsável pelo KiShow, o usuário poderá entrar em contato por meio do endereço de e-mail disponibilizado nesta Política de Privacidade.")
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "7")
                        Text("Direitos do Usuário")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section {
                    Text("O KiShow não utiliza cookies, tecnologias de rastreamento ou mecanismos de publicidade comportamental para acompanhar a atividade do usuário em outros aplicativos ou sites. Além disso, não há uso de analytics nem crash reporting.")
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "8")
                        Text("Cookies e tecnologias de rastreamento")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section {
                    Text("Podemos atualizar nossa Política de Privacidade periodicamente. Notificaremos sobre quaisquer alterações, publicando a nova Política de Privacidade nesta página.")

                    Text("Informaremos por meio de um aviso em destaque em nosso Serviço antes que a alteração entre em vigor e atualizaremos a data de \"Última atualização\" no início desta Política de Privacidade.")

                    Text("Recomendamos que revise esta documentação periodicamente para verificar a existência de alterações.")
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "9")
                        Text("Alterações nas Políticas de Privacidade")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)


                Section {
                    Text("**Email:** [kishowdeequipe@gmail.com](mailto:kishowdeequipe@gmail.com)")
                        .tint(Color.mainPink)
                        .environment(\.openURL, OpenURLAction { url in
                            pendingExternalURL = url
                            externalLinkMessage = "Você será direcionado ao app de e-mail para entrar em contato com a equipe do KiShow."
                            showExternalLinkConfirmation = true
                            return .handled
                        })

                } header: {
                    HStack{
                        TermsTopics(numberTerm: "10")
                        Text("Contato")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)

                Section {
                    Button("Ver versão online") {
                        pendingExternalURL = URL(string: "https://dequiz.github.io/KiShow/index.html")
                        externalLinkMessage = "Você será redirecionado para uma página externa com a política de privacidade."
                        showExternalLinkConfirmation = true
                    }
                    .foregroundStyle(Color.mainPink)
                }
                .listRowBackground(Color.details)

            }
            .background(Color.appBackground)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Políticas de Privacidade")
        .toolbarTitleDisplayMode(.inline)
        .overlay {
            PrimaryColorAlertPresenter(
                isPresented: $showExternalLinkConfirmation,
                title: "Você está saindo do KiShow",
                message: externalLinkMessage,
                confirmTitle: "Continuar",
                cancelTitle: "Cancelar",
                onConfirm: {
                    guard let url = pendingExternalURL else { return }
                    openURL(url)
                    pendingExternalURL = nil
                },
                onCancel: {
                    pendingExternalURL = nil
                }
            )
            .frame(width: 1, height: 1)
            .opacity(0.01)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }
}

#Preview {
    PrivacyPolicy()
}
