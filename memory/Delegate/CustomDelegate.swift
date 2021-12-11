//
//  CustomDelegate.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/12/07.
//

import Foundation


//protocol GuestCardUpdateDelegate: AnyObject {
//    func update(guest: Guest, updateGuestParam: Set<String>)
//}

///  Guestの入力情報をコントローラに引き継ぐ
protocol PassGuestItemDelegate: AnyObject {
    func pass<Element>(inputView: Element)
}
