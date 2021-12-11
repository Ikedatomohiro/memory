//
//  EventMenuViewController.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit
import FirebaseFirestore
import Alamofire

class EventMenuViewController: UIViewController {
    
    fileprivate let event: Event
    fileprivate var guests: [Guest]        = []
    fileprivate let moveGuestCardButton    = UIButton()
    fileprivate let moveGuestListButton    = UIButton()
    fileprivate let moveEventInfoButton    = UIButton()
    fileprivate let moveInputSettingButton = UIButton()
    fileprivate var retuals: [Retual]      = []
    fileprivate var relations: [Relation]  = []
    fileprivate var groups: [Group]        = []
    var collectionDict: Dictionary<String, [CollectionList]> = [:]
    
    let selectGuests                       = SelectGuests()
    lazy var eventInfoAreaView             = EventInfoAreaView(event: event, guests: guests, frame: .zero)
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBase()
        setupEventInfoArea()
        setupMoveGuestCardButton()
        setupMoveGuestListButton()
        setupMoveEventInfoButton()
        setupInputSettingButton()
        setBackButtonTitle()
        collectionDict = getCollectionList(eventId: event.eventId)
        getSelectListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //MARK:- Function
    fileprivate func setupBase() {
        navigationItem.title = event.eventName
        self.getSelectListData()
        self.view.backgroundColor = .white
    }
    
    fileprivate func setupEventInfoArea() {
        view.addSubview(eventInfoAreaView)
        eventInfoAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor)
    }
    
    fileprivate func fetchData() {
        selectGuests.fetchData(eventId: event.eventId) { (guests) in
            self.guests = guests
            // 参加者の登録数をセット
            self.eventInfoAreaView.setGuestsCount(count: guests.count)
        }
    }
    
    /// 参加者入力欄への遷移ボタン
    fileprivate func setupMoveGuestCardButton() {
        view.addSubview(moveGuestCardButton)
        buttonCustomise(button: moveGuestCardButton, text: "参加者入力")
        moveGuestCardButton.anchor(top: eventInfoAreaView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveGuestCardButton.accessibilityIdentifier = "guestInput"
        moveGuestCardButton.addTarget(self, action: #selector(moveViewController(_:)), for: .touchUpInside)
    }
    
    /// 参加者一覧への遷移ボタン
    fileprivate func setupMoveGuestListButton() {
        view.addSubview(moveGuestListButton)
        buttonCustomise(button: moveGuestListButton, text: "参加者一覧")
        moveGuestListButton.anchor(top: moveGuestCardButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveGuestListButton.accessibilityIdentifier = "guestList"
        moveGuestListButton.addTarget(self, action: #selector(moveViewController(_:)), for: .touchUpInside)
    }
    
    /// イベント情報への遷移ボタン
    fileprivate func setupMoveEventInfoButton() {
        view.addSubview(moveEventInfoButton)
        buttonCustomise(button: moveEventInfoButton, text: "イベント情報")
        moveEventInfoButton.anchor(top: moveGuestListButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveEventInfoButton.accessibilityIdentifier = "eventInfo"
        moveEventInfoButton.addTarget(self, action: #selector(moveViewController(_:)) ,for: .touchUpInside)
    }
    
    /// 入力項目設定画面への遷移ボタン
    fileprivate func setupInputSettingButton() {
        view.addSubview(moveInputSettingButton)
        buttonCustomise(button: moveInputSettingButton, text: "入力項目設定")
        moveInputSettingButton.anchor(top: moveEventInfoButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveInputSettingButton.accessibilityIdentifier = "guestInputSetting"
        moveInputSettingButton.addTarget(self, action: #selector(moveViewController(_:)) ,for: .touchUpInside)
    }
    
    /// ボタンのカスタマイズ
    fileprivate func buttonCustomise(button: UIButton, text: String) {
        button.setTitle(text, for: .normal)
        button.backgroundColor = green
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.layer.cornerRadius = 5
    }
    
    /// 各画面へ遷移
    @objc fileprivate func moveViewController(_ sender: UIButton)
    {
        var vc = UIViewController()
        let identifire = sender.accessibilityIdentifier
        
        switch identifire {
        case "guestInput":
            
            let defaultGuest = Guest("", retuals, relations, groups)
            
            vc = GuestCardViewController(event: event, guest: defaultGuest, collectionDict: collectionDict)
            break
        case "guestList":
            vc = GuestListViewController(event, retuals, guests)
            break
        case "eventInfo":
            vc = EventInfoViewController(event: event)
            break
        case "guestInputSetting":
            vc = GuestInputSettingViewController()
            break
        case .none: break
        case .some(_):
            break
        }
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 戻るボタンの名称をセット
    fileprivate func setBackButtonTitle() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "メニューに戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    /// 各種リストを取得
    fileprivate func getCollectionList(eventId: String) -> Dictionary<String, [CollectionList]> {
        for collection in DefaultParam.collections {
            
            CollectionList.collectionRef(eventId: eventId, collection: collection).order(by: "number").getDocuments() { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else { return }
                let collectionItem = documents.map({ (document) -> CollectionList in
                    let collectionItem = CollectionList(docment: document)
                    return collectionItem
                })
                self.collectionDict.updateValue(collectionItem, forKey: collection)
            }
        }
        return self.collectionDict
    }
    
    
    /// 儀式リストを取得
    fileprivate func getRetuals(eventId: String) -> [Retual] {
        Retual.collectionRef(eventId: eventId).order(by: "number").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.retuals = documents.map({ (document) -> Retual in
                let retual = Retual(docment: document)
                return retual
            })
        }
        return self.retuals
    }
    
    /// ご関係リストを取得
    fileprivate func getRelations(eventId: String) -> [Relation] {
        Relation.collectionRef(eventId: eventId).order(by: "number").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.relations = documents.map({ (documnt) -> Relation in
                let relation = Relation(docment: documnt)
                return relation
            })
        }
        return self.relations
    }
    
    /// 所属団体リストを取得
    fileprivate func getGroups(eventId: String) -> [Group] {
        Group.collectionRef(eventId: eventId).order(by: "number").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.groups = documents.map({ (documnt) -> Group in
                let group = Group(docment: documnt)
                return group
            })
        }
        return self.groups
    }
    
    /// 各選択ボタンリストを取得
    fileprivate func getSelectListData() {
        self.retuals = getRetuals(eventId: event.eventId)
        self.relations = getRelations(eventId: event.eventId)
        self.groups = getGroups(eventId: event.eventId)
    }
}
