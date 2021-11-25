//
//  GuestCardTableView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

import UIKit

class GuestCardTableView: UITableView {
    
    fileprivate var cellItems: Array<GuestInput.CellType>
    
    override init(frame: CGRect, style: UITableView.Style) {
        self.cellItems = GuestInput.CellType.cellTypelist
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

    func setCell(cellItem: GuestInput.CellType) -> UITableViewCell {
        let cell = GuestCardTableViewCell()
        var vc = UIView()
        switch cellItem {
        case GuestInput.CellType.guestName:
            vc = InputGuestPlainView(frame: .zero, labelText: "ご芳名", identifire: cellItem.rawValue)
            break
        case .companyName:
            vc = InputGuestPlainView(frame: .zero, labelText: "会社名", identifire: cellItem.rawValue)
            break
        case .zipCode:
            print("ゆうびん")
            break
        case .address:
            print("じゅうしょ")
            break
        case .telNumber:
            print("でんわ")
            break
        case .description:
            vc = InputGuestPlainView(frame: .zero, labelText: "備考", identifire: cellItem.rawValue)
            break
        }
        cell.setupCell(view: vc)
        
        return cell
    }
    
    
}
