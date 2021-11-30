//
//  GuestCardTableView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

import UIKit




class GuestCardTableView: UITableView {
    
    fileprivate var cellItems: Array<GuestInput.CellHeadLine>
    weak var passGuestItemDelegate: PassGuestItemDelegate?
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        self.cellItems = GuestInput.CellHeadLine.cellHeadLineList
        super.init(frame: .zero, style: style)
        // 区切り線を消す
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        switch cellItem {
        case .guestName:
            cellType = GuestInput.CellType.nomal
            headlineText = "ご芳名"
            break
        case .companyName:
            cellType = GuestInput.CellType.nomal
            headlineText = "会社名"
            break
        case .zipCode:
            headlineText = "郵便番号"

            print("ゆうびん")
            break
        case .address:
            headlineText = "住所"
            print("じゅうしょ")
            break
        case .telNumber:
            headlineText = "電話番号"
            print("でんわ")
            break
        case .description:
            headlineText = "備考"
            //            vc = InputGuestPlainView(frame: .zero, labelText: "備考", identifire: cellItem.rawValue)
            break
        }
        cell.setupCell(cellItem: cellItem, cellType: cellType ?? .nomal, headlineText: headlineText)
        cell.passGuestItemDelegate = self
        return cell
    }
}
extension GuestCardTableView: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        passGuestItemDelegate?.pass(inputView: inputView)
    }
}
