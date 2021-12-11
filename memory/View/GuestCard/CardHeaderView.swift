//
//  CardHeaderView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit

class CardHeaderView: UIView {
    fileprivate let cardTitleLabel  = UILabel()
    fileprivate let cardHeaderLabel = UILabel()
    fileprivate let guestId: String = ""
    fileprivate let pageLabel       = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupLabel()
    }
    
    fileprivate func setupLabel() {
        addSubview(cardHeaderLabel)
        cardHeaderLabel.text = Constants.GuestInputCardHeader
        cardHeaderLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        cardHeaderLabel.textAlignment = .center
    }
}
