//
//  GuestInputItem.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

struct GuestInput {
    let title: String
    let identifire: String
    
    enum CellType: String, CaseIterable {
        case guestName   = "guestName"
        case companyName = "companyName"
        case zipCode     = "zipCode"
        case address     = "address"
        case telNumber   = "telNumber"
        case description = "description"
        
        static let cellTypelist = CellType.allCases.map({ $0 })
    }
    
}
