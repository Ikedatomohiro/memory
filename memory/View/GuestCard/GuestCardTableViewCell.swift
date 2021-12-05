//
//  GuestCardTableViewCell.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

import UIKit

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
    func setupCell(cellItem: GuestInput.CellHeadLine, cellType: GuestInput.CellType, headlineText: String, textBody: String) {

        switch cellType {
        case .nomal:
            setupNomalCell(cellItem: cellItem, headlineText: headlineText, textBody: textBody)
        case .zipCode:
            setupZipCodeCell(cellItem: cellItem, headlineText: headlineText)
        case .telNumber:
            setupTexNumberCell(cellItem: cellItem, headlineText: headlineText)
        }
    }
    
    /// nomalのセルをセット
    fileprivate func setupNomalCell(cellItem: GuestInput.CellHeadLine, headlineText: String, textBody: String) {
        setupLabel(headlineText: headlineText)
        setupTextField(cellItem: cellItem, textBody: textBody)
        setUnderLine()
    }
    
    /// 郵便番号用のセルをセット
    fileprivate func setupZipCodeCell(cellItem: GuestInput.CellHeadLine, headlineText: String) {
        
    }

    /// 電話番号用のセルをセット
    fileprivate func setupTexNumberCell(cellItem: GuestInput.CellHeadLine, headlineText: String) {
        
    }
    
    /// ラベル
    func setupLabel(width: Int = Int(screenSize.width), headlineText: String) {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 15), size: .init(width: width / 6 , height: .zero))
        titleLabel.text = headlineText
        titleLabel.font = .systemFont(ofSize: 24)
    }
    
    /// 入力欄
    fileprivate func setupTextField(cellItem: GuestInput.CellHeadLine, textBody: String) {
        contentView.addSubview(textField)
        textField.anchor(top: topAnchor, leading: titleLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = inputAreaColor
        textField.accessibilityIdentifier = cellItem.rawValue
        textField.text = textBody
        self.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    /// アンダーラインをつける
    fileprivate func setUnderLine() {
        let underLine = UIView()
        addSubview(underLine)
        underLine.anchor(top: textField.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 0.5))
        underLine.backgroundColor = .black
    }
    
    /// 変更するたびに呼び出す
    @objc func textFieldDidChange(_ textFiled: UITextField) {
        pass(inputView: textField)
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
