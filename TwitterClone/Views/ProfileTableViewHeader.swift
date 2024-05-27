//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by 김선호 on 5/25/24.
//

import UIKit

class ProfileTableViewHeader: UIView { //script ProfileHeader
    
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
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        
    let profileHeaderImageViewConstraints = [
        profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
        profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
        profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        profileHeaderImageView.heightAnchor.constraint(equalToConstant: 180)
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
        
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraints)
        NSLayoutConstraint.activate(displayNameLabelConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(userBioLabelConstraints)
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        NSLayoutConstraint.activate(joinDateLabelConstraints)
    }

}
