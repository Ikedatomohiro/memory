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

protocol PassGuestItemDelegate: AnyObject {
    func pass<Element>(inputView: Element)
}

class GuestCardViewController: UIViewController {

    
    var event: Event
    var guest: Guest
    var retuals: [Retual]
    var relations: [Relation]
    var groups: [Group]
    var index: Int?
    lazy var guestCardTableView = GuestCardTableView(frame: .zero, style: .plain)
    
    weak var guestupdateDelegate: GuestCardUpdateDelegate?
    
    // UIView
    fileprivate let backGroundFrame    = UIView()
    fileprivate let cardHeaderView     = CardHeaderView()
    lazy var guestNameView = InputGuestPlainView(frame: .zero, labelText: "御芳名", identifire: "guestName")
    lazy var companyNameView = InputGuestPlainView(frame: .zero, labelText: "会社名", identifire: "companyName")
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
        
                setupGuestInputTableView()
        
//        setupGuestNameView()
//        setupCompanyNameView()
        
        
        
        
        
        
        
        
        
        
        //        setupCardTitleView()
        //        setupRetualsSelectView()
        //        setupBackgroundFrame()
        //        setupAddressView()
        //        setupSelectRelationView()
        //        setupSelectGroupView()
        //        setBackGroundFrameAnchor()
        //        setupDescriptionView()
        setupBackToMenuButton()
        setupRegistButton()
    }
    
    /// 表示アイテムを設定
    ///
    
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
    
    /// 入力欄テーブルをセット
    fileprivate func setupGuestInputTableView() {
        view.addSubview(guestCardTableView)
        guestCardTableView.anchor(top: cardHeaderView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
        guestCardTableView.passGuestItemDelegate = self
//        guestCardTableView.anchor(top: nil, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil)

//        registButton.anchor(top: nil, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 150, height: 40))
    }
    
    //    fileprivate func setupRetualsSelectView() {
    //        view.addSubview(retualCollectionView)
    //        retualCollectionView.anchor(top: cardHeaderView.bottomAnchor, leading: nil, bottom: nil, trailing: cardHeaderView.trailingAnchor, size: .init(width: 300, height: screenSize.height / 16))
    //        retualCollectionView.backgroundColor = .white
    //        retualCollectionView.guestItemUpdateDelegate = self
    //    }
    //
    /// デバイスの向きが変わった時を検知した時の処理
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                print("横向き表示です。")
                
            } else {
                print("縦向き表示です。")
            }
            
        }) { UIViewControllerTransitionCoordinatorContext in
            
            self.guestNameView.setupLabel(width: Int(size.width))
        }
    }
    
    fileprivate func setupGuestNameView() {
        view.addSubview(guestNameView)
        guestNameView.setupView()
        guestNameView.anchor(top: cardHeaderView.bottomAnchor, leading: self.view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: self.view.layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 10))
        guestNameView.passGuestItemDelegate = self
    }
    
    fileprivate func setupCompanyNameView() {
        view.addSubview(companyNameView)
        companyNameView.setupView()
        companyNameView.anchor(top: guestNameView.bottomAnchor, leading: self.view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: self.view.layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 10))
        companyNameView.passGuestItemDelegate = self
    }
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
        registButton.anchor(top: nil, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 150, height: 40))
        registButton.addTarget(self, action: #selector(registGuest), for: .touchUpInside)
    }
    
    @objc func registGuest() {
        // ボタンを動かす
        registButton.animateView(registButton)
        let defaultGuest = Guest("", retuals, relations, groups)
        // どの項目も入力されていなければ登録しない
        guard guest != defaultGuest else { return }
        // Firestoreに登録
        Guest.registGuest(guest, event.eventId)
        // TODO: -　登録完了アラート
        
        //  入力欄をリセットする
        resetGuest()
    }
    
    fileprivate func resetGuest() {
        

    }
    
    /// テキストフィールドから受け取った情報をGuestにセット
    fileprivate func setGuestInfo<Element>(inputView: Element) {
        if type(of: inputView) != UITextField.self { return }
        
        let textField = inputView as! UITextField
        let identifier = textField.accessibilityIdentifier
        let inputContent = GuestInput.CellHeadLine.self
        // 入ってきた情報により保存する情報を振り分ける
        switch identifier {
        case inputContent.guestName.rawValue:
            guest.guestName = textField.text ?? ""
            break
        case inputContent.companyName.rawValue:
            guest.companyName = textField.text ?? ""
            break
        case inputContent.zipCode.rawValue:
            guest.zipCode = textField.text ?? ""
            getAdress(zipcode: guest.zipCode)
            break
        case inputContent.address.rawValue:
            guest.address = textField.text ?? ""
            break
        case inputContent.telNumber.rawValue:
            guest.telNumber = textField.text ?? ""
            break
        case inputContent.description.rawValue:
            guest.description = textField.text ?? ""
            break

        default:
            break
        }
    }
    
    /// 郵便番号から住所を取得する
    fileprivate func getAdress(zipcode: String) {
        let addressObj = GetAddress.self
        addressObj.callZipCloudApi(zipcode: zipcode) { address in
            self.guest.address = address
            print(address)
//            return
        }
    }
}

// MARK: - Extensions

extension GuestCardViewController: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        self.setGuestInfo(inputView: inputView)
    }
    
}
