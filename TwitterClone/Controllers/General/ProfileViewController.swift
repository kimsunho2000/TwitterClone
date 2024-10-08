//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by 김선호 on 5/23/24.
//


import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden : Bool = true
    private var viewModel: ProfileViewViewModel
    
    init(viewModel: ProfileViewViewModel) { //init viewModel(ProfileViewViewModel),Do not force StoryBoard to be used.
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let statusBar : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 390))
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.tableHeaderView = headerView //add ProfileTableViewHeader
        profileTableView.contentInsetAdjustmentBehavior = .never //consider safeArea in scrollView
        navigationController?.navigationBar.isHidden = true
        configureConstraints()
        bindViews()
        viewModel.fetchUserTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func bindViews() { //binding views in app 
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.usernameLabel.text = "@\(user.username)"
            self?.headerView.followersCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBioLabel.text = user.bio
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            self?.headerView.joinDateLabel.text = "Joined \(user.createdOn)"
        }
        .store(in: &subscriptions)
        
    viewModel.$currentFollowingState.sink { [weak self] state in
        switch state {
        case .personal:
            self?.headerView.configureAsPersonal()
            return
        case .userIsFollowed:
            self?.headerView.configureFollowButtonAsUnFollowed()
            return
        case .userIsUnfollowed:
            self?.headerView.configureFollowButtonAsFollowed()
            return
        }
    }
    .store(in: &subscriptions)
        
        headerView.followButtonActionPublisher.sink { [weak self] state in
            switch state {
            case .userIsFollowed:
                self?.viewModel.unFollow()
            case .userIsUnfollowed:
                self?.viewModel.follow()
            case .personal:
                return
            }
        }
        .store(in: &subscriptions)
}
    private func configureConstraints() { //set layout constraints
        
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20) //consider non notch iphone and notch iphone
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource { //add tableView at ProfileVC
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as?
                TweetTableViewCell else {
        return UITableViewCell()
        }
        
        let tweet = viewModel.tweets[indexPath.row]
        cell.configureTweets(with: tweet.author.displayName, 
                             username: tweet.author.username,
                             tweetTextContent: tweet.tweetContent,
                             avatarPath: tweet.author.avatarPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //fix
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in self?.statusBar.layer.opacity = 1 } completion: {  _ in }
        }
        else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) { [weak self] in self?.statusBar.layer.opacity = 0 } completion: {  _ in }
        }
    }
}
