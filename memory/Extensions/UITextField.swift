//
//  UITextField.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit

extension UITextField {
    func setUnderLine() {
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 5)
        // 枠線の色
        underline.backgroundColor = .black
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}
