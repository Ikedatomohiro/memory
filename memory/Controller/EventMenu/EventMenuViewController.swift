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
//        getSelectListData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //MARK:- Function
    fileprivate func setupBase() {
        navigationItem.title = event.eventName
//        self.getSelectListData()
        self.view.backgroundColor = .white
    }
    
    fileprivate func setupEventInfoArea() {
        view.addSubview(eventInfoAreaView)
        eventInfoAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor)
    }
    
    fileprivate func fetchData() {
        selectGuests.fetchData(eventId: event.eventId) { (guests) in
            self.guests = guests
            // ?????????????????????????????????
            self.eventInfoAreaView.setGuestsCount(count: guests.count)
        }
    }
    
    /// ???????????????????????????????????????
    fileprivate func setupMoveGuestCardButton() {
        view.addSubview(moveGuestCardButton)
        buttonCustomise(button: moveGuestCardButton, text: "???????????????")
        moveGuestCardButton.anchor(top: eventInfoAreaView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveGuestCardButton.accessibilityIdentifier = "guestInput"
        moveGuestCardButton.addTarget(self, action: #selector(moveViewController(_:)), for: .touchUpInside)
    }
    
    /// ????????????????????????????????????
    fileprivate func setupMoveGuestListButton() {
        view.addSubview(moveGuestListButton)
        buttonCustomise(button: moveGuestListButton, text: "???????????????")
        moveGuestListButton.anchor(top: moveGuestCardButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveGuestListButton.accessibilityIdentifier = "guestList"
        moveGuestListButton.addTarget(self, action: #selector(moveViewController(_:)), for: .touchUpInside)
    }
    
    /// ???????????????????????????????????????
    fileprivate func setupMoveEventInfoButton() {
        view.addSubview(moveEventInfoButton)
        buttonCustomise(button: moveEventInfoButton, text: "??????????????????")
        moveEventInfoButton.anchor(top: moveGuestListButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveEventInfoButton.accessibilityIdentifier = "eventInfo"
        moveEventInfoButton.addTarget(self, action: #selector(moveViewController(_:)) ,for: .touchUpInside)
    }
    
    /// ?????????????????????????????????????????????
    fileprivate func setupInputSettingButton() {
        view.addSubview(moveInputSettingButton)
        buttonCustomise(button: moveInputSettingButton, text: "??????????????????")
        moveInputSettingButton.anchor(top: moveEventInfoButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveInputSettingButton.accessibilityIdentifier = "guestInputSetting"
        moveInputSettingButton.addTarget(self, action: #selector(moveViewController(_:)) ,for: .touchUpInside)
    }
    
    /// ??????????????????????????????
    fileprivate func buttonCustomise(button: UIButton, text: String) {
        button.setTitle(text, for: .normal)
        button.backgroundColor = green
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.layer.cornerRadius = 5
    }
    
    /// ??????????????????
    @objc fileprivate func moveViewController(_ sender: UIButton)
    {
        var vc = UIViewController()
        let identifire = sender.accessibilityIdentifier
        
        switch identifire {
        case "guestInput":
            vc = GuestCardViewController(event: event, collectionDict: collectionDict)
            break
        case "guestList":
            vc = GuestListViewController(event, guests: guests, collectionDict: collectionDict)
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
    
    // ????????????????????????????????????
    fileprivate func setBackButtonTitle() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "?????????????????????"
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    /// ????????????????????????
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

}
