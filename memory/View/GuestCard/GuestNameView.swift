//
//  GuestNameView.swift
//  Pods
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit
import PencilKit

class GuestNameView: UIView {
    fileprivate let guestNameTitleLabel = UILabel()
    let guestNameCanvas                 = PKCanvasView()
    fileprivate let guestNameTextField  = UITextField()
    fileprivate let honorificTitle      = UILabel()
    var guestNameImageData              = Data()
    weak var guestItemupdateDelegate: GuestItemUpdateDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupGuestNameTextField()
        setupLabel()
        setUnderLine()
        self.accessibilityIdentifier = "guestName"
    }
    

    /// ご芳名入力欄
    fileprivate func setupGuestNameTextField() {
        addSubview(guestNameTextField)
        guestNameTextField.anchor(top: topAnchor, leading: nil, bottom: layoutMarginsGuide.bottomAnchor, trailing: trailingAnchor, size: .init(width: screenSize.width * 3 / 4, height: .zero))
        guestNameTextField.font = UIFont.systemFont(ofSize: 40)
        
    }
    
    /// ご芳名ラベル
    fileprivate func setupLabel() {
        addSubview(guestNameTitleLabel)
        guestNameTitleLabel.text = "御芳名"
        guestNameTitleLabel.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: guestNameTextField.leadingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 15))
        guestNameTitleLabel.font = .systemFont(ofSize: 24)
    }
    
    /// アンダーラインをつける
    fileprivate func setUnderLine() {
        let underLine = UIView()
        addSubview(underLine)
        underLine.anchor(top: guestNameTextField.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 0.5))
        underLine.backgroundColor = .black
    }
    
    /// 変更されたら保存する
    
}
