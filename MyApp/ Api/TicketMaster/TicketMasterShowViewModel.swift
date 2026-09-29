//
//  TicketMasterShowViewModel.swift
//  MyApp
//
//  Created by Paulo Eduardo Barbosa da Silva on 29/09/26.
//




class TicketMasterShowViewModel{
    var show: [TicketmasterShow] = []

    func fetchConcert() async {
        show = await WebService().downloadData()
    }
    
    
}
