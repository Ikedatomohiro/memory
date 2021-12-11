//
//  Retual.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/13.
//

import FirebaseFirestore

struct Retual {
    var id         : String
    var number     : Int // 順番保持用
    var retualName : String
    let eventId    : String
    let createdAt  : Date
    var updatedAt  : Date

    init(name: String) {
        self.id         = ""
        self.number     = 0
        self.retualName = name
        self.eventId    = ""
        self.createdAt  = Date()
        self.updatedAt  = Date()
    }
    
    init(docment: QueryDocumentSnapshot) {
        let dictionary  = docment.data()
        self.id         = docment.documentID
        self.number     = dictionary["number"]     as? Int    ?? 0
        self.retualName = dictionary["name"] as? String ?? ""
        self.eventId    = dictionary["eventID"]    as? String ?? ""
        self.createdAt  = dictionary["createdAt"]  as? Date   ?? Date()
        self.updatedAt  = dictionary["updatedAt"]  as? Date   ?? Date()
    }
    
    
    static func collectionRef(eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("retual")
    }
    
    static func registRetual(retual: Retual, eventId: String, number: Int) {
        Retual.collectionRef(eventId: eventId).addDocument(data: [
            "number"     : number,
            "retualName" : retual.retualName,
            "eventId"    : eventId,
            "createdAt"  : Date(),
            "updatedAt"  : Date()
        ])
        return
    }
}
