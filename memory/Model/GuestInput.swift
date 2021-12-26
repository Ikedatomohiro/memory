//
//  GuestInputItem.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

struct GuestInput {
    let title: String
    let identifire: String
    
    enum CellType: CaseIterable {
        case nomal
        case zipCode
        case telNumber
        case collection
        
        static let cellTypeList = CellType.allCases.map({ $0 })
    }
    
    enum CellHeadLine: String, CaseIterable {
        case retual      = "retual"
        case guestName   = "guestName"
        case companyName = "companyName"
        case zipCode     = "zipcode"
        case address     = "address"
        case telNumber   = "telNumber"
        case relation    = "relation"
        case group       = "group"
        case description = "description"

        static let cellHeadLineList = CellHeadLine.allCases.map({ $0 })
    }
    
}
