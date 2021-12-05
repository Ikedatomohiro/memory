//
//  GuestCardTableView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

import UIKit

class GuestCardTableView: UITableView {
    
    var guest: Guest
    fileprivate var cellItems: Array<GuestInput.CellHeadLine>
    weak var passGuestItemDelegate: PassGuestItemDelegate?
    
    
    init(guest: Guest, frame: CGRect, style: UITableView.Style) {
        self.cellItems = GuestInput.CellHeadLine.cellHeadLineList
        self.guest = guest
        super.init(frame: .zero, style: style)
        // 区切り線を消す
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 参加者データをもとにリロードする
    func reloadGuestdata(guest: Guest) {
        self.guest = guest
        self.reloadData()
    }
    
    /// 参加者情報をリセットしてリロード
    func resetInputData(guest: Guest) {
        self.guest = guest
        self.reloadData()
    }
    
}

// MARK: - Extentions
extension GuestCardTableView: UITableViewDelegate {
    
}

extension GuestCardTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setCell(cellItem: cellItems[indexPath.section])
        print(indexPath.section)
        return cell
    }
    
    // リスト高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height / 10
    }
    
    func setCell(cellItem: GuestInput.CellHeadLine) -> UITableViewCell {
        let cell = GuestCardTableViewCell()
        var cellType: GuestInput.CellType?
        var headlineText: String = ""
        var textBody: String = ""
        switch cellItem {
        case .guestName:
            cellType = GuestInput.CellType.nomal
            headlineText = "ご芳名"
            textBody = guest.guestName
            break
        case .companyName:
            cellType = GuestInput.CellType.nomal
            headlineText = "会社名"
            textBody = guest.companyName
            break
        case .zipCode:
            headlineText = "郵便番号"
            textBody = guest.zipCode
            break
        case .address:
            headlineText = "住所"
            textBody = guest.address
            break
        case .telNumber:
            headlineText = "電話番号"
            textBody = guest.telNumber
            break
        case .description:
            headlineText = "備考"
            textBody = guest.description
            break
        }
        cell.setupCell(cellItem: cellItem, cellType: cellType ?? .nomal, headlineText: headlineText, textBody: textBody)
        cell.passGuestItemDelegate = self
        return cell
    }
}
extension GuestCardTableView: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        passGuestItemDelegate?.pass(inputView: inputView)
    }
}
