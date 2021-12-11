//
//  GuestCardTableViewCell.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

import UIKit
import FirebaseFirestore

class GuestCardTableViewCell: UITableViewCell {

    let textField = UITextField()
    var titleLabel = UILabel()
    var labelText = ""
    let identifire = ""
    weak var passGuestItemDelegate: PassGuestItemDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// セルをセットする
    func setupCell(cellItem: GuestInput.CellHeadLine, cellType: GuestInput.CellType, headlineText: String, textBody: String, collectionDict: Dictionary<String, [CollectionList]>) {

        switch cellType {
        case .nomal:
            setupNomalCell(cellItem: cellItem, headlineText: headlineText, textBody: textBody)
        case .zipCode:
            setupZipCodeCell(cellItem: cellItem, headlineText: headlineText, textBody: textBody)
        case .telNumber:
            setupTexNumberCell(cellItem: cellItem, headlineText: headlineText)
        case .collection:
            setupCollectionCell(cellItem: cellItem, headlineText: headlineText, collectionDict: collectionDict)
        }
    }
    
    /// nomalのセルをセット
    fileprivate func setupNomalCell(cellItem: GuestInput.CellHeadLine, headlineText: String, textBody: String) {
        let plainView = InputGuestPlainView(frame: frame, labelText: headlineText, identifire: cellItem.rawValue, textBody: textBody)
        plainView.passGuestItemDelegate = self
        contentView.addSubview(plainView)
        plainView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 15), size: .init(width: screenSize.width / 6 , height: .zero))
    }
    
    /// 郵便番号用のセルをセット
    fileprivate func setupZipCodeCell(cellItem: GuestInput.CellHeadLine, headlineText: String, textBody: String) {
        let zipcodeView = InputGuestZipcodeView(frame: frame, labelText: headlineText, identifire: cellItem.rawValue, textBody: textBody)
        zipcodeView.passGuestItemDelegate = self
        contentView.addSubview(zipcodeView)
        zipcodeView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 15), size: .init(width: screenSize.width / 6 , height: .zero))
    }

    /// 電話番号用のセルをセット
    fileprivate func setupTexNumberCell(cellItem: GuestInput.CellHeadLine, headlineText: String) {
        
    }
    
    fileprivate func setupCollectionCell(cellItem: GuestInput.CellHeadLine, headlineText: String, collectionDict: Dictionary<String, [CollectionList]>) {
        switch cellItem {
        case .retual:
            break
        case .relation:
            var relationCollectionView = InputGuestCollectionView(cellItem: cellItem, frame: CGRect.zero)

            break
        case .group:
            
            break
        default:
            break
        }
        
    }
}

// MARK: - Extensions
extension GuestCardTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = inputAreaFocasColor
    }
    
    // テキストフィールドの編集が終わった時に呼び出されるデリゲートメソッド
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = inputAreaColor
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    // 画面をタッチするとキーボードが閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

extension GuestCardTableViewCell: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        passGuestItemDelegate?.pass(inputView: inputView)
    }
}
