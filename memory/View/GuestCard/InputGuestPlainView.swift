//
//  InputGuestPlainView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/23.
//

import UIKit

class InputGuestPlainView: UIView {

    let textField = UITextField()
    var titleLabel = UILabel()
    var labelText = ""
    let identifire: String
    weak var guestItemupdateDelegate: GuestItemUpdateDelegate?
    
    init(frame: CGRect, labelText: String, identifire: String) {
        self.identifire = identifire
        self.titleLabel.text = labelText
        super.init(frame: frame)
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupLabel()
        setupTextField()
        setUnderLine()
        self.accessibilityIdentifier = identifire
    }
    
    /// ラベル
    func setupLabel(width: Int = Int(screenSize.width)) {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 15), size: .init(width: width / 6 , height: .zero))
        titleLabel.font = .systemFont(ofSize: 24)
    }
    
    /// 入力欄
    fileprivate func setupTextField() {
        addSubview(textField)
        textField.anchor(top: topAnchor, leading: titleLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = inputAreaColor
    }
    
    /// アンダーラインをつける
    fileprivate func setUnderLine() {
        let underLine = UIView()
        addSubview(underLine)
        underLine.anchor(top: textField.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 0.5))
        underLine.backgroundColor = .black
    }
}
// MARK: - Extensions
extension InputGuestPlainView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = inputAreaFocasColor
    }
    
    // テキストフィールドの編集が終わった時に呼び出されるデリゲートメソッド
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = inputAreaColor
    }
    
    // 画面をタッチするとキーボードが閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
