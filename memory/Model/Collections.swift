//
//  Collections.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/12/07.
//

import Foundation
import FirebaseFirestore

struct CollectionList {
    var id        : String
    var number    : Int // 順番保持用
    var name      : String
    let createdAt : Date
    var updatedAt : Date

    init(name: String) {
        self.id        = ""
        self.number    = 0
        self.name      = name
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(docment: QueryDocumentSnapshot) {
        let dictionary = docment.data()
        self.id        = docment.documentID
        self.number    = dictionary["number"] as? Int ?? 0
        self.name      = dictionary["name"] as? String ?? ""
        self.createdAt = (dictionary["createdAt"] as! Timestamp).dateValue()
        self.updatedAt = (dictionary["updatedAt"] as! Timestamp).dateValue()
    }
    
    static func registCollection(collection: String, eventId: String, number: Int, name: String) {
        collectionRef(eventId: eventId, collection: collection).addDocument(data: [
            "number"    : number,
            "name"      : name,
            "createdAt" : Date(),
            "updatedAt" : Date()
        ])
        return
    }
    
    static func collectionRef(eventId: String, collection: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection(collection)
    }
}
