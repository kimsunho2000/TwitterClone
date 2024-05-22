//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by 김선호 on 5/19/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //add tableview at Homeview
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as?   TweetTableViewCell //cast optionally
        else {
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: TweetTableViewCellDelegate { //implement TweetTableViewCellDelegate
    func tweetTableViewCellDidTapReply() {
        print("1")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("2")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("3")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("4")
    }
    
    
}
