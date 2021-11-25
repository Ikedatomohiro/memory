//
//  GuestCardTableViewCell.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/25.
//

import UIKit

class GuestCardTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// セルをセットする
    func setupCell(view: UIView) {
        // contentviewにしないと、Cellの下になって、記入できない。
        contentView.addSubview(view)
        view.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }

}
