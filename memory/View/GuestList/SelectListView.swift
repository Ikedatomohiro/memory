//
//  SelectListView.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2022/01/10.
//

import UIKit

class SelectListView: UIView {
    
    var collectionDict: Dictionary<String, [CollectionList]>
    var name: String
    fileprivate let guestSortTypePickerView = UIPickerView()
    
    init (collectionDict: Dictionary<String, [CollectionList]>, name: String, frame: CGRect) {
        self.collectionDict = collectionDict
        self.name = name
        super.init(frame: frame)
        setupGuestSortPickerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGuestSortPickerView() {
        var list: [CollectionList] = []
        // セレクトボックスを作成
        var noIdlist = CollectionList.init(name: "---")
        list.append(noIdlist)
        if let tmplist = collectionDict[name] {
            list = tmplist
            list.insert(noIdlist, at: 0)
        }
        guestSortTypePickerView.delegate = self
        guestSortTypePickerView.dataSource = self
        // はじめに表示する項目を指定
        guestSortTypePickerView.selectRow(0, inComponent: 0, animated: true)
        
        // 画面にピッカーを追加
        addSubview(guestSortTypePickerView)
        guestSortTypePickerView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: 120, height: .zero))
    }
}
// MARK: Extensions
extension SelectListView: UIPickerViewDelegate {
    
}

extension SelectListView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 1
        if let list = collectionDict[name] {
            // 「---」の項目を追加するため「+1」する
            count = list.count + 1
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var column = "---"
        // 「---」の分を追加する処理
        if row == 0 { return column }
        if let list = collectionDict[name] {
            column = list[row - 1].name
        }
        return column
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //        print(retualList[row])
        //        sendRetualDelegate?.selectGuestsByRetual(retual: retualList[row])
        
    }
}
