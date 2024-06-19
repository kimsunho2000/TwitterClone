//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by 김선호 on 5/25/24.
//

import UIKit

class ProfileTableViewHeader: UIView { //script ProfileHeader
    
    private enum SectionTabs : String { //set index of SectionTabs
        case tweets = "Tweets"
        case tweetsAndReplises = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
        
        var index : Int {
            switch self {
            case .tweets:
                return 0
            case .tweetsAndReplises:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    }
    private var selectedTab : Int = 0 {
        didSet{
            print(selectedTab) //use Property Observer,it will detect value changing
        }
    }
    
    private var tabs : [UIButton] = ["Tweets", "Tweets & Replies", "Media", "Likes"].map { buttonTitle in //make buttons
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private lazy var sectionStack : UIStackView = { //add stackview,contain tabsButton
        var stackView = UIStackView()
        stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let followersTextLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Follwers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let followersCountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1M"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let followingTextLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight:  .regular)
        return label
    }()
    
    private let followingCountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "314"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let joinDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joined May 2024"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14,weight: .regular)
        return label
    }()
    
    
    private let joinDateImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar",withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userBioLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .label
        label.text = "IOS"
        return label
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@sunhokim28"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let displayNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sun ho"
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
        
    }()
    
    private let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.image = UIImage(named: <#T##String#>)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let profileAvatarImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .yellow
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(displayNameLabel)
        addSubview(usernameLabel)
        addSubview(userBioLabel)
        addSubview(joinDateImageView)
        addSubview(joinDateLabel)
        addSubview(followingCountLabel)
        addSubview(followingTextLabel)
        addSubview(followersCountLabel)
        addSubview(followersTextLabel)
        addSubview(sectionStack)
        configureConstraints()
        configureStackButton()

    }
    
    private func configureStackButton() {
        for (_, button) in sectionStack.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.tweets.rawValue:
            selectedTab = 0
        case SectionTabs.tweetsAndReplises.rawValue:
            selectedTab = 1
        case SectionTabs.media.rawValue:
            selectedTab = 2
        case SectionTabs.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        
    let profileHeaderImageViewConstraints = [
        profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
        profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
    ]
        
    let profileAvatarImageViewConstraints = [
        profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
        profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10),
        profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
        profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80)
    ]
    
    let displayNameLabelConstraints = [
        displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
        displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor,constant: 20)
    ]
    
    let usernameLabelConstraints = [
        usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
        usernameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5)
    ]
        
    let userBioLabelConstraints = [
        userBioLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
        userBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -5),
        userBioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor,constant: 5)
    ]
    
    let joinDateImageViewConstraints = [
        joinDateImageView.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
        joinDateImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor,constant: 5)
    ]
    
    let joinDateLabelConstraints = [
        joinDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor,constant: 2),
        joinDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
    ]
        
    let followingCountLabelConstraints = [
        followingCountLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
        followingCountLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant:  10)
        ]
    
    let followingTextLabelConstraints = [
        followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 4),
        followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
    ]
        
    let followersCountLabelConstraints = [
        followersCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor, constant: 8),
        followersCountLabel.bottomAnchor.constraint(equalTo: followingTextLabel.bottomAnchor)
    ]
    
    let followersTextLabelConstraints = [
        followersTextLabel.leadingAnchor.constraint(equalTo: followersCountLabel.trailingAnchor, constant: 4),
        followersTextLabel.bottomAnchor.constraint(equalTo: followersCountLabel.bottomAnchor)
    ]
        
    let sectionStackConstraints = [
        sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
        sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
        sectionStack.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 5),
        sectionStack.heightAnchor.constraint(equalToConstant: 25)
    ]
        
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(userBioLabelConstraints)
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        NSLayoutConstraint.activate(joinDateLabelConstraints)
        NSLayoutConstraint.activate(followingCountLabelConstraints)
        NSLayoutConstraint.activate(followingTextLabelConstraints)
        NSLayoutConstraint.activate(followersCountLabelConstraints)
        NSLayoutConstraint.activate(followersTextLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)
        
    }

}
