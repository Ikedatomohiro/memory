//
//  InputGuestCollectionViewCell.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/12/07.
//

import UIKit

class CheckBoxCell: UICollectionViewCell {
    
    let label = UILabel()
    var isActive: Bool = false
    var id = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(label)
        label.fillSuperview()
        label.textAlignment = .center
    }
    
    func setupContents(collection: CollectionList, identifire: String) {
        label.text = collection.name
        label.font = .systemFont(ofSize: 24)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.backgroundColor = gray
        self.accessibilityIdentifier = identifire
        self.id = collection.id
    }
    
    func setButtonColor(isActive: Bool) {
        if isActive == true {
            label.backgroundColor = gray
            self.isActive = false
        } else if isActive == false {
            label.backgroundColor = green
            self.isActive = true
        }
    }
    
    func animateView(_ viewToAnimate:UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                viewToAnimate.transform = .identity
                
            }, completion: nil)
        }
    }
}
