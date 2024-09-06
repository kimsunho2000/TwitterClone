//
//  SearchResultsViewController.swift
//  TwitterClone
//
//  Created by 김선호 on 9/2/24.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var users: [TwitterUser] = []
    
    private let searchResultsTableView: UITableView = { //add tableview
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        table.rowHeight = 60 //instead of using extension func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultsTableView)
        configureConstraints()
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
    }
    
    func update(users: [TwitterUser]) {
        self.users = users
        DispatchQueue.main.async { [weak self] in
            self?.searchResultsTableView.reloadData()
        }
    }
    
    private func configureConstraints() {
        let searchResultsTableViewConstraints = [
            searchResultsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(searchResultsTableViewConstraints)
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell
        else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.row]
        let profileViewModel = ProfileViewViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileViewModel)
        present(vc, animated: true)
    }
}
