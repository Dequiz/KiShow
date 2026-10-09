//
//  ThermsOfService.swift
//  MyApp
//
//  Created by Maria Clara Fernandes Bessa on 30/09/26.
//

import SwiftUI

struct ThermsOfService: View {
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Leia este Contrato com atenção e assegure-se de que entende o seu conteúdo. Caso não entenda ou não aceite alguma parte deste documento, não utilize o Serviço.")
                         
                    Text("O presente Termo de Uso possui como objetivo regulamentar o modo de utilização do aplicativo KiShow,  sendo este voltado para o registro a preservação de memórias e sentimentos das experiências vividas em shows. O App é exclusivo para Iphone (sistema IOS) e disponibilizado gratuitamente na Apple Store.")
                    
                    Text("Ao utilizar o aplicativo, o usuário aceita e concorda integralmente com todos os termos e condições que serão apresentadas nesta documentação.")

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
                    
                    Text("O aplicativo faz uso da API Discovery da Ticketmaster para consultar informações públicas relacionadas a eventos e shows, as quais são utilizadas exclusivamente para apresentar opções de eventos ao usuário dentro do aplicativo. Nos responsabilizamos por disponibilizar apenas a consulta dos eventos sem enviar nenhum tipo de dado pessoal do usuário para que o acesso ocorra.")
                    
                    Text("KiShow não realiza a venda, processamento ou gerenciamento de ingressos. Caso o usuário seja direcionado para uma plataforma externa para obter informações ou realizar uma compra, essa interação estará sujeita aos termos e à política de privacidade do respectivo serviço de terceiros.")
                    
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
                    Text("O uso do aplicativo não é recomendado para menores de 18 anos. Não nos responsabilizamos pelo uso indevido do menor de idade, ficando a cargo dos responsáveis legais a supervisão e autorização prévia para a utilização")
                    
                    Text("O usuário possui apenas uma licença limitada, não exclusiva, intransferível e revogável para uso pessoal e não comercial do software. É vetada qualquer forma de distribuição, reprodução, modificação ou disponibilização do aplicativo que não seja pelo canal oficial da App Store. Qualquer outro meio de obtenção do aplicativo em outros meios será considerado pirataria.")
                 
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
                    BulletTopic(text: "Toda inserção de conteúdos que mostre um indivíduo em situação vexatória ou que infrinja sua privacidade.")
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
                    
                    Text("Reservamo-nos o direito de atualizar os Termos de Uso através de avisos prévios no aplicativo.")
                    
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
                    Text("Todos os direitos de propriedade intelectual e comercial relativos ao aplicativo KiShow, o que inclui códigos fontes, marcas, logos, ilustrações, interfaces e o próprio software, são de propriedade exclusiva da Equipe de Desenvolvimento KiShow, sendo esta composta por André Holovati, Elisa Tanada Giacomini da Silva, Maria Clara Fernandes Bessa e Paulo Eduardo Barbosa da Silva. ")
                    
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
                    Text("Vigência a partir de 23/09/2026.")
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.details)
            }
            .background(Color.appBackground)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Termos de Uso")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    ThermsOfService()
}
