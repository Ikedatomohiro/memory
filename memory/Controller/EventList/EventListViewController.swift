//
//  EventListViewController.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/11.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import AdSupport
import AppTrackingTransparency


protocol EventListViewControllerDelegate: AnyObject {
    func moveTosignPage()
}

///  イベントリストを表示するトップページ
class EventListViewController: UIViewController {
    fileprivate var uid                = ""
    let titleLabel                     = UILabel()
    fileprivate let logInButton        = UIButton()
    fileprivate let createEventButton  = UIButton()
    fileprivate let db                 = Firestore.firestore()
    fileprivate let eventNameTextField = UITextField()
    lazy var eventListTableView        = EventListTableView(events: events, frame: .zero, style: .plain)
    fileprivate var events             = [Event]()
    fileprivate let defaultRetuals     = DefaultParam.retuals
    fileprivate let defaultRelations   = DefaultParam.relations
    fileprivate let defaultGroups      = DefaultParam.groups
    fileprivate var number: Int        = 0
//    fileprivate let sideMenuVC         = SideMenuViewController()
    fileprivate var sideMenuAppearance = false
    weak var eventListViewContollerDelegate:EventListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 非表示にしたNavigationControllerを再度表示させる
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
//        // サインアウト
//        let firebaseAuth = Auth.auth()
//    do {
//      try firebaseAuth.signOut()
//        print("サインアウトしました。")
//    } catch let signOutError as NSError {
//      print("Error signing out: %@", signOutError)
//    }
      
                setupBase()
//        fetchEventList()
//        setupCreateEventButton()
//        setupEventListTableView()
//        setBackButtonTitle()
//        setupSettingImage()

    }
    
    /// 基本設定
    fileprivate func setupBase() {
        if !signInCheck() {
            moveToSignInPage()
        } else {
            print("ログインしました")
        }
        
    }
    
    /// Firestoreからイベント名リストを取得
    /// - Parameters:
    ///    - paramA: なし
    /// - Returns: void
    fileprivate func fetchEventList() {
        let uid = Auth.auth().currentUser!.uid
        db.collection("events").whereField("uids", arrayContains: uid).getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.events = documents.map{ (document) -> Event in
                return Event(document: document)
            }
            self.eventListTableView.reloadEventListData(events: self.events)
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    /// サインインチェック
    /// - Returns: Bool
    fileprivate func signInCheck() -> Bool {
        if Auth.auth().currentUser != nil {
            print("signed in \(String(describing: Auth.auth().currentUser!.uid))")
            uid = Auth.auth().currentUser!.uid
            return true
        } else {
            print("サインインしてください。")
            return false
        }
        
    }
    
    /// サインインページに遷移
    fileprivate func moveToSignInPage() {
        let signInVC = SignInViewController()
        signInVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    
    
}
