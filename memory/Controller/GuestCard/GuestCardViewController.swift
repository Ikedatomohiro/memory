//
//  GuestCardViewController.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit
import FirebaseFirestore

class GuestCardViewController: UIViewController {
    
    
    var event: Event
    var guest: Guest
    var collectionDict: Dictionary<String, [CollectionList]>
    lazy var guestCardTableView = GuestCardTableView(guest: guest, collectionDict: collectionDict, frame: .zero, style: .plain)
    
    // UIView
    fileprivate let backGroundFrame    = UIView()
    fileprivate let cardHeaderView     = CardHeaderView()
    fileprivate let backToMenuButton   = UIButton()
    fileprivate var captureImage       = UIImage()
    var updateGuestParam = Set<String>()
    fileprivate let registButton       = UIButton()

    // MARK: - init
    init(event: Event, collectionDict: Dictionary<String, [CollectionList]>) {
        self.event = event
        self.collectionDict = collectionDict
        self.guest = Guest.init("", collectionDict)
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
        cardHeaderView.setupView()
    }
    
    /// ?????????????????????????????????
    fileprivate func setupGuestInputTableView() {
        view.addSubview(guestCardTableView)
        guestCardTableView.anchor(top: cardHeaderView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
        guestCardTableView.passGuestItemDelegate = self
    }
    /// ??????????????????????????????????????????????????????????????????
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                print("????????????????????????")
                
            } else {
                print("????????????????????????")
            }
            
        }) { UIViewControllerTransitionCoordinatorContext in
            
        }
    }
    
    /// ??????????????????????????????
    fileprivate func setupBackToMenuButton() {
        view.addSubview(backToMenuButton)
        backToMenuButton.setTitle("<< ?????????????????????", for: .normal)
        backToMenuButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil)
        backToMenuButton.setTitleColor(.black, for: .normal)
        backToMenuButton.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
    }
    
    /// ???????????????????????????????????????????????????????????????
    @objc func backToMenu() {
        // ???????????????????????????
        self.navigationController?.popViewController(animated: true)
        // ??????????????????NavigationController????????????????????????
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// ???????????????
    fileprivate func setupRegistButton() {
        view.addSubview(registButton)
        registButton.buttonCustomise(registButton, "????????????")
        registButton.anchor(top: nil, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: 150, height: 40))
        registButton.addTarget(self, action: #selector(registGuest), for: .touchUpInside)
    }
    
    @objc func registGuest() {
        // ?????????????????????
        registButton.animateView(registButton)
        let defaultGuest = Guest("", [:])
        // ????????????????????????????????????????????????????????????
        guard guest != defaultGuest else { return }
        // Firestore?????????
        Guest.registGuest(guest, event.eventId)
        // TODO: -???????????????????????????
        
        // ??????????????????????????????
        self.guest = defaultGuest
        guestCardTableView.resetInputData(guest: defaultGuest)
    }
    
    /// ?????????????????????????????????????????????????????????Guest????????????
    fileprivate func setGuestInfo<Element>(inputView: Element) {
        if type(of: inputView) == UITextField.self  {
            let textField = inputView as! UITextField
            let identifier = textField.accessibilityIdentifier
            
            let inputContent = GuestInput.CellHeadLine.self
            // ??????????????????????????????????????????????????????????????????
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
        } else if type(of: inputView) == CheckBoxCell.self {
            let checkBoxCell = inputView as! CheckBoxCell
            print(checkBoxCell.isActive)
            let identifire = checkBoxCell.accessibilityIdentifier
            let inputContent = GuestInput.CellHeadLine.self

            switch identifire {
            case inputContent.retual.rawValue:
                if var selectDict = guest.selectDict["retuals"] {
                    selectDict[checkBoxCell.id] = checkBoxCell.isActive
                    guest.selectDict["retuals"] = selectDict
                }
                break
            case inputContent.relation.rawValue:
                if var selectDict = guest.selectDict["relations"] {
                    selectDict[checkBoxCell.id] = checkBoxCell.isActive
                    guest.selectDict["relations"] = selectDict
                }
                break
            case inputContent.group.rawValue:
                if var selectDict = guest.selectDict["groups"] {
                    selectDict[checkBoxCell.id] = checkBoxCell.isActive
                    guest.selectDict["groups"] = selectDict
                }
                break
            default:
                break
            }
        } else {
            return
        }
    }
    
    /// ???????????????????????????????????????
    fileprivate func getAdress(zipcode: String) {
        let addressObj = GetAddress.self
        addressObj.callZipCloudApi(zipcode: zipcode) { address in
            self.guest.address = address
            self.guestCardTableView.reloadGuestdata(guest: self.guest)
        }
    }
}

// MARK: - Extensions

extension GuestCardViewController: PassGuestItemDelegate {
    func pass<Element>(inputView: Element) {
        self.setGuestInfo(inputView: inputView)
    }
    
}
