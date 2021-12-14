//
//  SelectCollectionView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/12/12.
//

import UIKit

class SelectCollectionView: UICollectionView {
    
    var cellItem: GuestInput.CellHeadLine
    var collections: [CollectionList]
    
    weak var passGuestItemDelegate: PassGuestItemDelegate?
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    // MARK: - Init
    init(cellItem: GuestInput.CellHeadLine, collections: [CollectionList], frame: CGRect) {
        self.cellItem = cellItem
        self.collections = collections
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.dataSource = self
        self.delegate = self
        self.register(CheckBoxCell.self, forCellWithReuseIdentifier: CheckBoxCell.className)
        self.accessibilityIdentifier = cellItem.rawValue
    }
}

// MARK: - Extensions
extension SelectCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var collectionCount = 0
        collectionCount = collections.count
//        switch cellItem {
//        case .retual:
//            collectionCount = DefaultParam.retuals.count
//        case .relation:
//            collectionCount = DefaultParam.relations.count
//            break
//        default:
//            break
//        }
//        
        return collectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCell.className, for: indexPath) as! CheckBoxCell
        
        cell.setupContents(collection: collections[indexPath.item], identifire: cellItem.rawValue)
        //        // 対象のセルのIDをセット
        //        let relationId = relations[indexPath.item].id
        //        let relation = guest.relations[relationId] ?? false
        //        cell.setButtonColor(isActive: relation)
        return cell
    }
}

extension SelectCollectionView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // クリックしたときのアクション
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // セルを選択
        let cell = collectionView.cellForItem(at: indexPath) as! CheckBoxCell
        // 選択されたセルを揺らす
        cell.animateView(cell.label)
        
        cell.setButtonColor(isActive: cell.isActive)
        
        // guestsの配列データを更新
        pass(inputView: cell)
    }
}

extension SelectCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 30)
    }
    // セルの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    // セル同士の縦間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // セル同士の横間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension SelectCollectionView: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        passGuestItemDelegate?.pass(inputView: inputView)
    }
}

