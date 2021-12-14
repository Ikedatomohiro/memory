//
//  Guest.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/11.
//

import FirebaseFirestore
import CoreFoundation

struct Guest {
    var id: String
    let eventId: String
    var guestName: String
    var companyName: String
//    var retuals: Dictionary<String, Bool> = [:]
    var zipCode: String
    var address: String
    var telNumber: String
//    var relations: Dictionary<String, Bool> = [:]
//    var groups: Dictionary<String, Bool> = [:]
    var description: String
    var selectDict: Dictionary<String, Dictionary<String, Bool>> = [:]
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    // MARK: -
    init(document: QueryDocumentSnapshot) {
        let dictionary   = document.data()
        self.id          = document.documentID
        self.eventId     = dictionary["eventId"]     as? String ?? ""
        self.guestName   = dictionary["guestName"]   as? String ?? ""
        self.companyName = dictionary["companyName"] as? String ?? ""
//        self.retuals     = dictionary["retuals"]     as? Dictionary<String, Bool> ?? [:]
        self.zipCode     = dictionary["zipCode"]     as? String ?? ""
        self.address     = dictionary["address"]     as? String ?? ""
        self.telNumber   = dictionary["telNumber"]   as? String ?? ""
//        self.relations   = dictionary["relations"]   as? Dictionary<String, Bool> ?? [:]
//        self.groups      = dictionary["groups"]      as? Dictionary<String, Bool> ?? [:]
        self.description = dictionary["description"] as? String ?? ""
        self.selectDict  = dictionary["selectList"]  as? Dictionary<String, Dictionary<String, Bool>> ?? [:]
        self.createdAt   = dictionary["createdAt"]   as? Date   ?? Date()
        self.updatedAt   = dictionary["updatedAt"]   as? Date   ?? Date()
    }
    
    init(_ id: String,_ collectionDict: Dictionary<String, [CollectionList]>) {
        self.id          = id
        self.eventId     = ""
        self.guestName   = ""
        self.companyName = ""
        self.zipCode     = ""
        self.address     = ""
        self.telNumber   = ""
        self.description = ""
        self.selectDict  = setSelectList(collectionDict: collectionDict)
        
//        self.retuals     = setDefaultAttendance(retualList: retualList)
//        self.relations   = setDefaultRelation(relationList: relationList)
//        self.groups      = setDefaultGroup(groupList: groupList)
    }
    
    static func registGuest(_ guest: Guest, _ eventId: String) -> Void {
        Guest.collectionRef(eventId).addDocument(data: [
            "guestName"   : guest.guestName,
            "companyName" : guest.companyName,
//            "retuals"     : guest.retuals,
            "zipCode"     : guest.zipCode,
            "address"     : guest.address,
            "telNumber"   : guest.telNumber,
//            "relations"   : guest.relations,
//            "groups"      : guest.groups,
            "description" : guest.description,
            "selectDict" : guest.selectDict,
            "eventId"     : eventId,
            "createdAt"   : Date(),
            "updatedAt"   : Date(),
        ])
        return
    }

    static func updateGuest(_ guest: Guest, _ eventId: String, _ analizedText: Dictionary<String, String>?) {
       Guest.collectionRef(eventId).document(guest.id).updateData([
        "guestName"   : guest.guestName,
        "companyName" : guest.companyName,
//        "retuals"     : guest.retuals,
        "zipCode"     : guest.zipCode,
        "address"     : guest.address,
        "telNumber"   : guest.telNumber,
//        "relations"   : guest.relations,
//        "groups"      : guest.groups,
        "description" : guest.description,
        "selectDict" : guest.selectDict,
        "updatedAt"   : Date(),
        ])
    }
    
    static func collectionRef(_ eventId: String) -> CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    func setSelectList(collectionDict: Dictionary<String, [CollectionList]>) -> Dictionary<String, Dictionary<String, Bool>> {
        var selectDict: Dictionary<String, Dictionary<String, Bool>> = [:]
        for collection in collectionDict {
            selectDict[collection.key] = collection.value.reduce(into: [String: Bool]()) { $0[$1.id] = false }
        }
        return selectDict
    }
    
    // 儀式の参列をデフォルト不参加にセット。デフォルトのretualsListの配列をDictionary型に変換して返す。
    func setDefaultAttendance(retualList: [Retual]) -> Dictionary<String, Bool> {
        return retualList.reduce(into: [String: Bool]()) { $0[$1.id] = false }
    }
    
    func setDefaultRelation(relationList: [Relation]) -> Dictionary<String, Bool> {
        return relationList.reduce(into: [String: Bool]()) { $0[$1.id] = false }
    }
    
    func setDefaultGroup(groupList: [Group]) -> Dictionary<String, Bool> {
        return groupList.reduce(into: [String: Bool]()) { $0[$1.id] = false }
    }
}

// MARK: - Extensions
// 入力されているかどうかチェック
extension Guest: Equatable {
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.guestName   == rhs.guestName
            && lhs.companyName == rhs.companyName
//            && lhs.retuals     == rhs.retuals
            && lhs.zipCode     == rhs.zipCode
            && lhs.address     == rhs.address
            && lhs.telNumber   == rhs.telNumber
//            && lhs.relations   == rhs.relations
            && lhs.description == rhs.description
            && lhs.selectDict == rhs.selectDict
    }
}
