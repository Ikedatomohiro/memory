//
//  InputCollectionView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/12/07.
//

import UIKit

class InputGuestSelectView: UIView {
    
    var titleLabel = UILabel()
    var labelText = ""
    let identifire: String
    let collections: [CollectionList]
    lazy var selectCollectionView = SelectCollectionView(identifire: identifire, collections: collections, frame: frame)
    weak var passGuestItemDelegate: PassGuestItemDelegate?
    
    // MARK: - Init
    init(frame: CGRect, labelText: String, identifire: String, collections: [CollectionList]) {
        self.identifire = identifire
        self.titleLabel.text = labelText
        self.collections = collections
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupLabel()
        setupSelectCollectionView()
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
    fileprivate func setupSelectCollectionView() {
        addSubview(selectCollectionView)
        selectCollectionView.anchor(top: topAnchor, leading: titleLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        selectCollectionView.passGuestItemDelegate = self
    }
    
    /// アンダーラインをつける
    fileprivate func setUnderLine() {
        let underLine = UIView()
        addSubview(underLine)
        underLine.anchor(top: selectCollectionView.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 0.5))
        underLine.backgroundColor = .black
    }
}
// MARK: - Extensions
extension InputGuestSelectView: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        passGuestItemDelegate?.pass(inputView: inputView)
    }
}
