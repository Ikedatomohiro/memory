//
//  InputGuestZipcodeView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/12/07.
//

import UIKit

class InputGuestZipcodeView: UIView {
    
    let zipcodeTextField1 = UITextField()
    let zipcodeMarkLabel = UILabel()
    var titleLabel = UILabel()
    var labelText = ""
    let identifire: String
    let textBody: String
    weak var passGuestItemDelegate: PassGuestItemDelegate?

    init(frame: CGRect, labelText: String, identifire: String, textBody: String) {
        self.identifire = identifire
        self.titleLabel.text = labelText
        self.textBody = textBody
        super.init(frame: frame)
        zipcodeTextField1.delegate = self
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 入力項目を設置
    fileprivate func setupView() {
        setupLabel()
        setupZipcodeMark()
        setupTextField()
    }
    
    /// ラベル
    func setupLabel(width: Int = Int(screenSize.width)) {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 15), size: .init(width: width / 6 , height: .zero))
        titleLabel.font = .systemFont(ofSize: 24)
    }

    /// 郵便番号マークを設置
    fileprivate func setupZipcodeMark() {
        zipcodeMarkLabel.text = "〒"
        zipcodeMarkLabel.font = .systemFont(ofSize: 24)
        addSubview(zipcodeMarkLabel)
        zipcodeMarkLabel.anchor(top: topAnchor, leading: titleLabel.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: 30 , height: .zero))
    }
    
    /// 入力欄
    fileprivate func setupTextField() {
        addSubview(zipcodeTextField1)
        zipcodeTextField1.anchor(top: topAnchor, leading: zipcodeMarkLabel.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        zipcodeTextField1.font = UIFont.systemFont(ofSize: 28)
        zipcodeTextField1.layer.cornerRadius = 5
        zipcodeTextField1.backgroundColor = inputAreaColor
        zipcodeTextField1.accessibilityIdentifier = identifire
        zipcodeTextField1.text = textBody
        zipcodeTextField1.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    /// アンダーラインをつける
    fileprivate func setUnderLine() {
        let underLine = UIView()
        addSubview(underLine)
        underLine.anchor(top: zipcodeTextField1.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 0.5))
        underLine.backgroundColor = .black
    }
    
    /// 変更するたびに呼び出す
    @objc func textFieldDidChange(_ textField: UITextField) {
        pass(inputView: textField)
    }
}
// MARK: - Extensions
extension InputGuestZipcodeView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = inputAreaFocasColor
    }
    
    // テキストフィールドの編集が終わった時に呼び出されるデリゲートメソッド
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = inputAreaColor
        pass(inputView: textField)
    }
    
    // 画面をタッチするとキーボードが閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

extension InputGuestZipcodeView: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        passGuestItemDelegate?.pass(inputView: inputView)
    }
}
