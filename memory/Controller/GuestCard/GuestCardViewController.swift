//
//  GuestCardViewController.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import PencilKit

protocol GuestCardUpdateDelegate: AnyObject {
    func update(guest: Guest, updateGuestParam: Set<String>)
}

protocol GuestItemUpdateDelegate: AnyObject {
    func update<T>(inputView: T)
}

class GuestCardViewController: UIViewController {
    
    var event: Event
    var guest: Guest
    var retuals: [Retual]
    var relations: [Relation]
    var groups: [Group]
    var index: Int?
    weak var guestupdateDelegate: GuestCardUpdateDelegate?
    
    // UIView
    fileprivate let backGroundFrame    = UIView()
    fileprivate let cardHeaderView     = CardHeaderView()
//    fileprivate let cardTitleView      = CardTitleView()
    fileprivate let guestNameView      = GuestNameView()
//    fileprivate let companyNameView    = CompanyNameView()
//    fileprivate let addressView        = AddressView()
//    fileprivate let descriptionView    = DescriptionView()
    fileprivate let backToMenuButton   = UIButton()
    fileprivate var captureImage       = UIImage()
    var updateGuestParam = Set<String>()
    fileprivate let storage            = Storage.storage().reference(forURL: Keys.firestoreStorageUrl)
    fileprivate let registButton       = UIButton()
//    lazy var retualCollectionView = RetualCollectionView(guest, retuals, frame: CGRect.zero)
//    lazy var selectRelationView = SelectRelationView(guest, relations, relationCollectionView, frame: CGRect.zero)
//    lazy var relationCollectionView = RelationCollectionView(guest, relations, frame: CGRect.zero)
//    lazy var selectGroupView = SelectGroupView(guest, groups, groupCollectionView, frame: CGRect.zero)
//    lazy var groupCollectionView = GroupCollectionView(guest, groups, frame: CGRect.zero)
    
    init(event: Event, guest: Guest, retuals: [Retual], relations: [Relation], groups: [Group]) {
        self.event = event
        self.guest = guest
        self.retuals = retuals
        self.relations = relations
        self.groups = groups
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- layout
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupBasic()
        setupCardHeaderView()
        
        
        
        
        
        
        
        
        
        
//        setupCardTitleView()
//        setupRetualsSelectView()
//        setupBackgroundFrame()
        setupGuestNameView()
//        setupCompanyNameView()
//        setupAddressView()
//        setupSelectRelationView()
//        setupSelectGroupView()
//        setBackGroundFrameAnchor()
//        setupDescriptionView()
        setupBackToMenuButton()
        setupRegistButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    fileprivate func setupBasic() {
        view.backgroundColor = .white
    }
    
    fileprivate func setupCardHeaderView() {
        view.addSubview(cardHeaderView)
        cardHeaderView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: .zero, height: screenSize.height / 20))
        cardHeaderView.setupView(index: index)
    }
    
//    fileprivate func setupCardTitleView() {
//        view.addSubview(cardTitleView)
//        cardTitleView.anchor(top: cardHeaderView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: screenSize.width / 2, height: screenSize.height / 16))
//        cardTitleView.setupView()
//    }
//
//    fileprivate func setupRetualsSelectView() {
//        view.addSubview(retualCollectionView)
//        retualCollectionView.anchor(top: cardHeaderView.bottomAnchor, leading: nil, bottom: nil, trailing: cardHeaderView.trailingAnchor, size: .init(width: 300, height: screenSize.height / 16))
//        retualCollectionView.backgroundColor = .white
//        retualCollectionView.guestItemUpdateDelegate = self
//    }
//
//    fileprivate func setupBackgroundFrame() {
//        view.addSubview(backGroundFrame)
//    }
//
    fileprivate func setupGuestNameView() {
        view.addSubview(guestNameView)
        guestNameView.setupView(guest: guest)
        guestNameView.anchor(top: cardHeaderView.bottomAnchor, leading: self.view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: self.view.layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 10))
//        guestNameView.layer.borderWidth = 1.0
        guestNameView.guestItemupdateDelegate = self
    }
//
//    fileprivate func setupCompanyNameView() {
//        view.addSubview(companyNameView)
//        companyNameView.setupView(guest: guest)
//        companyNameView.anchor(top: backGroundFrame.topAnchor, leading: guestNameView.trailingAnchor, bottom: guestNameView.bottomAnchor, trailing: backGroundFrame.trailingAnchor, size: .zero)
//        companyNameView.layer.borderWidth = 1.0
//        companyNameView.guestItemupdateDelegate = self
//    }
//
//    fileprivate func setupAddressView() {
//        view.addSubview(addressView)
//        addressView.setupView(guest: guest)
//        addressView.anchor(top: guestNameView.bottomAnchor, leading: guestNameView.leadingAnchor, bottom: nil, trailing: companyNameView.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 5))
//        addressView.layer.borderWidth = 1.0
//        addressView.guestItemupdateDelegate = self
//    }
//
//    // どなたのご関係ですか？
//    fileprivate func setupSelectRelationView() {
//        view.addSubview(selectRelationView)
//        selectRelationView.anchor(top: addressView.bottomAnchor, leading: backGroundFrame.leadingAnchor, bottom: nil, trailing: backGroundFrame.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 12))
//        selectRelationView.guestItemUpdateDelegate = self
//    }
//
//    // どのようなご関係ですか？
//    fileprivate func setupSelectGroupView() {
//        view.addSubview(selectGroupView)
//        selectGroupView.anchor(top: selectRelationView.bottomAnchor, leading: backGroundFrame.leadingAnchor, bottom: nil, trailing: backGroundFrame.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 10))
//        selectGroupView.guestItemUpdateDelegate = self
//    }
    
    // ここでbackGroundFrameのanchorを書くといいのではないか
    fileprivate func setBackGroundFrameAnchor() {
//        backGroundFrame.anchor(top: cardTitleView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
////        backGroundFrame.translatesAutoresizingMaskIntoConstraints = false
////        backGroundFrame.topAnchor.constraint(equalTo: cardTitleView.bottomAnchor)
////        backGroundFrame.topAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
//
//
//
//        backGroundFrame.accessibilityIdentifier = "backGroundFrame"
//        backGroundFrame.layer.borderWidth = 2.0
    }
    
//    // 備考
//    fileprivate func setupDescriptionView() {
//        view.addSubview(descriptionView)
//        descriptionView.setupView(guest: guest)
//        descriptionView.anchor(top: backGroundFrame.bottomAnchor, leading: backGroundFrame.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: backGroundFrame.trailingAnchor)
//        descriptionView.guestItemupdateDelegate = self
//    }
    
    /// メニューに戻るボタン
    fileprivate func setupBackToMenuButton() {
        view.addSubview(backToMenuButton)
        backToMenuButton.setTitle("<< メニューに戻る", for: .normal)
        backToMenuButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil)
        backToMenuButton.setTitleColor(.black, for: .normal)
        backToMenuButton.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
    }
    
    /// メニューに戻るボタンがタップされた時の処理
    @objc func backToMenu() {
        // メニュー画面に戻る
        self.navigationController?.popViewController(animated: true)
        // 非表示にしたNavigationControllerを再度表示させる
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// 登録ボタン
    fileprivate func setupRegistButton() {
        view.addSubview(registButton)
        registButton.buttonCustomise(registButton, "入力完了")
        registButton.anchor(top: guestNameView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 40))
        registButton.addTarget(self, action: #selector(registGuest), for: .touchUpInside)
    }
    
    @objc func registGuest() {
        guest.guestName = guestNameView.guestNameTextField.text ?? ""
        let defaultGuest = Guest("", retuals, relations, groups)

        guard guest != defaultGuest else { return }
        Guest.registGuest(guest, event.eventId)
        resetGuest()
        
    }
    
    fileprivate func resetGuest() {
        guestNameView.guestNameTextField.text = ""
    }

}

// MARK: - Extensions
extension GuestCardViewController: GuestItemUpdateDelegate {
    func update<T>(inputView: T) {
        guard let identifier = (inputView as! UIView).accessibilityIdentifier else { return }
        updateGuestParam.insert(identifier)
        // 各変更項目に対して値を更新する
        if identifier == "guestName" {
//            guest.guestNameImageData = guestNameView.guestNameCanvas.drawing.dataRepresentation()
            guest.guestName = guestNameView.guestNameTextField.text ?? ""
//        } else if identifier == "companyName" {
//            guest.companyNameImageData = companyNameView.companyNameCanvas.drawing.dataRepresentation()
//        } else if identifier == "zipCode" {
//            guest.zipCodeImageData = addressView.zipCodeCanvas.drawing.dataRepresentation()
//        } else if identifier == "address" {
//            guest.addressImageData = addressView.addressCanvas.drawing.dataRepresentation()
//        } else if identifier == "telNumber" {
//            guest.telNumberImageData = addressView.telNumberCanvas.drawing.dataRepresentation()
//        } else if identifier == "retuals" {
//            guest.retuals = retualCollectionView.guest.retuals
//        } else if identifier == "groups" {
//            guest.groups = groupCollectionView.guest.groups
//        } else if identifier == "relations" {
//            guest.relations = relationCollectionView.guest.relations
//        } else if identifier == "description" {
//            guest.descriptionImageData = descriptionView.descriptionCanvas.drawing.dataRepresentation()
        }
        print(updateGuestParam)
        guestupdateDelegate?.update(guest: guest, updateGuestParam: updateGuestParam)
    }
}
