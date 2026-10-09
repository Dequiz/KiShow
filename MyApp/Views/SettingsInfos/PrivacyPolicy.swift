//
//  PrivacyPolicy.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Esta Política de Privacidade descreve nossas políticas e procedimentos relativos à coleta, uso e divulgação de suas informações quando você utiliza o Serviço, além de informar sobre seus direitos de privacidade e como a lei o protege.")
                         
                    Text("Utilizamos seus Dados Pessoais para fornecer e aprimorar o Serviço. Coletamos e usamos suas informações conforme descrito nesta Política de Privacidade e quando exigido pela legislação aplicável. Neste ultimo caso, seu consentimento deve e será considerado.")
                    
                    Text("Dessa forma, a Equipe de Desenvolvimento KiShow, composta pelos integrantes: André Holovati, Elisa Tanada Giacomini da Silva, Maria Clara Fernandes Bessa e Paulo Eduardo Barbosa da Silva, se responsabiliza pelo cumprimento dos termos criados.")
                    
                } header: {
                    VStack (alignment: .leading) {
                        Text ("Última atualização: 23 de setembro de 2026")
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
                    BulletTopic(text: "Nome Completo;")
                    BulletTopic(text: "Idade;")
                    BulletTopic(text: "Imagens;")
                    BulletTopic(text: "Videos;")
                    BulletTopic(text: "Audios.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "2")
                        Text("Dados coletados pelo app")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("**Dados de Perfil (Nome Completo e data de nascimento):** Coletados exclusivamente para a criação e personalização da experiência do usuário dentro do aplicativo. ")
                    
                    Text("**Arquivos de Mídia (Imagens, Vídeos e Áudios):** O aplicativo solicita permissão de acesso à câmera, galeria e microfone para permitir que o usuário crie registros e guarde recordações dos shows aos quais compareceu.")
                    
                    Text("**Arquivos de áudio (uso do microfone):** Utilizados quando necessário para a gravação de conteúdos em áudio ou para captura de áudio associada aos vídeos.")
                    
                    Text("Todas as imagens, vídeos e áudios inseridos no aplicativo são processadas e armazenados exclusivamente de forma local no dispositivo do usuário. O aplicativo não realiza upload, não armazena cópias em servidores externos e não tem acesso remoto a esses arquivos.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "3")
                        Text("Finalidade da coleta de dados")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("A proteção dos dados é estritamente feita a partir da segurança local do dispositivo, não possuindo servidores e atores externos dentro do aplicativo.")
                    
                    Text("**Adendo importante:** apesar da adoção de medidas de segurança, nenhum sistema ou dispositivo pode garantir segurança absoluta contra todos os riscos existentes.")
                 
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "4")
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
                    Text("**Exclusão Total e Definitiva:** O usuário pode apagar a totalidade dos dados coletados pelo aplicativo e armazenado localmente no seu aparelho simplesmente desinstalando o aplicativo do dispositivo (ou limpando os dados na aba de configurações do sistema operacional).")
                    
                    Text("Em caso de dúvidas ou solicitações relacionadas ao tratamento de dados pessoais eventualmente realizado pela equipe responsável pelo KiShow, o usuário poderá entrar em contato por meio do endereço de e-mail disponibilizado nesta Política de Privacidade.")
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "5")
                        Text("Direitos do Usuário")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("O KiShow não utiliza cookies, tecnologias de rastreamento ou mecanismos de publicidade comportamental para acompanhar a atividade do usuário em outros aplicativos ou sites.")
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "6")
                        Text("Cookies e tecnologias de rastreamento")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                Section {
                    Text("Podemos atualizar nossa Política de Privacidade periodicamente. Notificaremos sobre quaisquer alterações, publicando a nova Política de Privacidade nesta página.")
                    
                    Text("Informaremos por meio de um aviso em destaque em nosso Serviço antes que a alteração entre em vigor e atualizaremos a data de \"Última atualização\" no início desta Política de Privacidade.")
                    
                    Text("Recomendamos que revise esta documentação  periodicamente para verificar a existência de alterações.")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "7")
                        Text("Alterações nas Políticas de Privacidade")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
                
                
                Section {
                    Text("**André Holovati:** andreholovati@gmail.com")
                    
                    Text("**Elisa Tanada:** elisa.tanada25@gmail.com")
                    
                    Text("**Maria Bessa:** clarafernandes597@gmail.com")
                    
                    Text("**Paulo Eduardo:** pauloeduardob75@gmail.com")
                    
                } header: {
                    HStack{
                        TermsTopics(numberTerm: "8")
                        Text("Contato")
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
            }
            .background(Color.appBackground)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Políticas de Privacidade")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    PrivacyPolicy()
}
