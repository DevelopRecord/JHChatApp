//
//  NewMessageController.swift
//  ChatApp
//
//  Created by LeeJaeHyeok on 2022/04/04.
//

import UIKit

protocol NewMessageControllerDelegate: AnyObject {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController: BaseViewController {

    // MARK: - Properties

    private var users = [User]()
    private var filteredUsers = [User]()
    weak var delegate: NewMessageControllerDelegate?
    private let searchController = UISearchController(searchResultsController: nil)

    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.rowHeight = 80
        $0.delegate = self
        $0.dataSource = self
        $0.register(NewMessageCell.self, forCellReuseIdentifier: NewMessageCell.identifier)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "새로운 메시지", prefersLargeTitle: false)
    }

    // MARK: - API

    func fetchUsers() {
        showLoader(true)
        Service.fetchUser { users in
            self.showLoader(false)

            self.users = users
            self.tableView.reloadData()
        }
    }

    // MARK: - Helpers

    override func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleDismissal))
        configureSearchController()

    }

    override func configureConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "사용자 검색"
        definesPresentationContext = false

        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .secondarySystemBackground
        }
    }

    // MARK: - Selectors

    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewMessageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewMessageCell.identifier, for: indexPath) as! NewMessageCell
        cell.backgroundColor = .secondarySystemBackground
        let users = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.setData(profileImage: users.profileImageUrl, nickname: users.nickname, fullname: users.fullname)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }

        filteredUsers = users.filter({ user in
            return user.fullname.contains(searchText) || user.nickname.contains(searchText)
        })

        self.tableView.reloadData()
    }
}
