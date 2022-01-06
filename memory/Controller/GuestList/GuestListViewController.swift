//
//  GuestListViewController.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/11/21.
//

import UIKit
import FirebaseFirestore

class GuestListViewController: UIViewController {
    
    fileprivate let event: Event
    fileprivate var guests: [Guest]
    var collectionDict: Dictionary<String, [CollectionList]>
    lazy var guestSortAreaView = GuestControllAreaView(collectionDict: collectionDict, frame: .zero)

    lazy var guestListTableView = GuestListTableView(guests: guests, frame: .zero, style: .plain)
    fileprivate var pageNumber: Int = 1
    var selectRetualId: String = ""
    var selectRank: Dictionary<String, Bool?> = [:]
    let selectGuests = SelectGuests()
    var listener: ListenerRegistration?
    
    init(_ event: Event, guests: [Guest] ,collectionDict: Dictionary<String, [CollectionList]>) {
        self.event = event
        self.guests = guests
        self.collectionDict = collectionDict
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setSortRetual()
        setupGuestListTableView()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        guard let _ =  self.navigationController?.viewControllers.last as? GuestEditViewController else {
//            listener?.remove()
//            return
//        }
    }
    
    fileprivate func fetchData() {
        selectGuests.fetchData(eventId: event.eventId) { (guests) in
            let guestsListener = self.selectGuests.collectionRef(self.event.eventId).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else { return }
                self.guests = documents.map{Guest(document: $0)}
                // GuestListTableView内でリロード
                self.guestListTableView.reloadGuestsData(guests: self.guests)
            }
            self.listener = guestsListener
        }
    }
    
    fileprivate func setupBasic() {
        view.backgroundColor = .white
        // 戻るボタンの名称をセット
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "参加者一覧に戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    
    fileprivate func setSortRetual() {
        view.addSubview(guestSortAreaView)
        guestSortAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: .zero, height: screenSize.height / 10))
        guestSortAreaView.sendRetualDelegate = self
    }

    fileprivate func setupGuestListTableView() {
        view.addSubview(guestListTableView)
        guestListTableView.anchor(top: guestSortAreaView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        guestListTableView.transitionDelegate = self
        guestListTableView.changeGuestsRankDelegate = self
        // TableViewをセット
        guestListTableView.register(GuestListCell.self, forCellReuseIdentifier: GuestListCell.className)
        guestListTableView.separatorStyle = .none
        // 下にスワイプで再読み込み
        guestListTableView.refreshControl = UIRefreshControl()
        guestListTableView.refreshControl?.addTarget(self, action: #selector(pullDownTableView), for: .valueChanged)
    }
    
    @objc func pullDownTableView() {
        self.selectGuests.fetchData(eventId: self.event.eventId) { (guests) in
            self.guests = guests
            self.guestListTableView.reloadGuestsData(guests: guests)
            self.guestListTableView.refreshControl?.endRefreshing()
            self.guestSortAreaView.resetGuestSortPickerview()
        }
    }
    
    fileprivate func reloadData(_ guests: [Guest]) {
        // TabeleViewにguestsを渡す
        self.guestListTableView.reloadGuestsData(guests: guests)
        // csvファイル作成ボタンのguestsを更新
        self.guestSortAreaView.updateGuestsData(guests)
    }
}

// MARK: - Extensions
extension GuestListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.guestListTableView.reloadData()
    }
}

extension GuestListViewController: TransitionGuestDetailDelegate {
    func sendTransitionIndex(_ guests: [Guest], _ index: Int) {
//        let guestEditVC = GuestEditViewController(guests: guests, index: index)
//        guestEditVC.modalTransitionStyle = .coverVertical
//        self.navigationController?.pushViewController(guestEditVC, animated: true)
    }
}

extension GuestListViewController: SendRetualDelegate {
    func selectGuestsByRetual(retual: CollectionList) {
        // リスト番号リセット
        self.pageNumber = 1
        if retual.id != "" {
            firestoreQueue.async {
                self.selectGuests.selectGuestsFromRetual(eventId: self.event.eventId, retualId: retual.id) { (guests) in
                    DispatchQueue.main.async {
                        // TabeleViewにguestsを渡す
                        print("guest:\(guests.count)")
                        self.reloadData(guests)
                    }
                }
            }
        } else {
            firestoreQueue.async {
                self.selectGuests.selectGuestAll(eventId: self.event.eventId) { (guests) in
                    DispatchQueue.main.async {
                        // TabeleViewにguestsを渡す
                        print("guest:\(guests.count)")
                        self.reloadData(guests)
                    }
                }
            }
        }
    }
}

extension GuestListViewController: ChangeGuestsRankDelegate {
    func changeGuestsRank(guests: [Guest], selectRank: Dictionary<String, Bool?>, sortColumn: Int) {
        self.selectRank = selectRank
        let selectGuests = SelectGuests()
        var guests_temp = guests
        self.guests = selectGuests.sortGuests(guests: &guests_temp, selectRank: selectRank, sortColumn: sortColumn)
        self.reloadData(guests_temp)
    }
}
