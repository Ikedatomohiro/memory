//
//  SelectGuests.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

let firestoreQueueGroup = DispatchGroup()
let firestoreQueue  = DispatchQueue.global(qos: .userInitiated)

class SelectGuests {
    
    var guests: [Guest] = []
    
    func collectionRef(_ eventId: String) -> CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    func fetchData(eventId: String, completion: @escaping ([Guest]) -> Void) {
        Guest.collectionRef(eventId).order(by:"createdAt").getDocuments { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    let guest = Guest(document: document)
                    return guest
                })
                completion(self.guests)
            } else {
                print("取得に失敗しました。")
                print(error as Any)
                return
            }
        }
    }
    
    func selectGuestsFromRetual(eventId: String, retualId: String, completion: @escaping ([Guest]) -> Void) {
        // 得られた情報からデータを検索
        self.collectionRef(eventId).whereField("retuals.\(retualId)", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    let guest = Guest(document: document)
                    return guest
                })
                completion(self.guests)
            } else {
                print(error as Any)
                return
            }
        }
    }
    
    func selectGuestAll(eventId: String, completion: @escaping ([Guest]) -> Void) {
        Guest.collectionRef(eventId).order(by:"createdAt").getDocuments { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    let guest = Guest(document: document)
                    return guest
                })
                completion(self.guests)
            } else {
                print(error as Any)
                return
            }
        }
    }
    
    func sortGuests(guests: inout [Guest], selectRank: Dictionary<String, Bool?>, sortColumn: Int) -> [Guest] {
        var tempGuest = guests
        if sortColumn == Constants.RankGuestName {
            if let guestRank = selectRank["guestName"] {
                if guestRank! {
                    tempGuest.sort(by: {$0.guestName < $1.guestName})
                } else if !guestRank! {
                    tempGuest.sort(by: {$0.guestName > $1.guestName})
                }
            } else {
                tempGuest.sort(by: {$0.createdAt < $1.createdAt})
            }
            guests = tempGuest
        } else if sortColumn == Constants.RankCompaneName {
            if let guestRank = selectRank["companyName"] {
                if guestRank! {
                    tempGuest.sort(by: {$0.companyName < $1.companyName})
                } else if !guestRank! {
                    tempGuest.sort(by: {$0.companyName > $1.companyName})
                }
            } else {
                tempGuest.sort(by: {$0.createdAt < $1.createdAt})
            }
            guests = tempGuest
        }
        
        return guests
    }
    
    func getGuestCard(_ guest: Guest) -> StorageReference {
        let filename = "\(guest.id)_guestCard.png"
        let storageURL = Keys.firestoreStorageUrl
        let storageRef = Storage.storage().reference(forURL: storageURL).child(filename)
        return storageRef
    }
}
