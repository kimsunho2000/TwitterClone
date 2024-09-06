//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by 김선호 on 5/19/24.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var composeTweetButton: UIButton = {
        
        let button = UIButton(type: .system, primaryAction:  UIAction {
            [weak self] _ in
            self?.navigateToTweetComposer()
            
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.tintColor = .white
        let plusSign = UIImage(systemName: "plus", withConfiguration:UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
     
    private func configureNavigationBar() {  //add NavigationBar
        let size : CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitterLogo") //image located Assets
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size)) //located in middle of navigationBar
        middleView.addSubview(logoImageView)
        
        navigationItem.titleView = middleView
    
        let profileImage = UIImage(systemName: "person") //located in left of navigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(didTapProfile))
    }
    
    @objc private func didTapProfile() {
        guard let user = viewModel.user else { return }
        let profileViewModel = ProfileViewViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileViewModel)
        navigationController?.pushViewController(vc, animated: true)    }
    
    private let timelineTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        view.addSubview(composeTweetButton)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        configureNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right.fill"), style: .plain, target: self, action: #selector(didTapSignOut))
        bindViews()
    }
    
    @objc private func didTapSignOut () { //exception handler
        try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
        configureConstraints()
    }
    
    private func handleAuthentication() {
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated:  false)
        }
    }
    
    private func navigateToTweetComposer() {
        let vc = UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retreiveUser()
    }
    
    func completeUserOnboarding() {
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    func bindViews() { //if view did't binded,it will call ProfiledateFormViewControllrer()
        viewModel.$user.sink {
            [weak self] user in
            guard let user = user else {
                return
            }
            if !user.isUserOnboarded {
                self?.completeUserOnboarding()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in //refresh table view
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
            }
        } .store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        let composeTweetButtonConstraints = [
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 60),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(composeTweetButtonConstraints)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //add tableview at Homeview
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as?   TweetTableViewCell //cast optionally
        else {
            return UITableViewCell()
        }
        let tweetModel = viewModel.tweets[indexPath.row] //bind datas in tableViewCell
        cell.configureTweets(with: tweetModel.author.displayName,
                             username: tweetModel.author.username,
                             tweetTextContent: tweetModel.tweetContent,
                             avatarPath: tweetModel.author.avatarPath)
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
