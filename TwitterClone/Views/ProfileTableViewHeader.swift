//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by 김선호 on 5/25/24.
//

import UIKit

class ProfileTableViewHeader: UIView { //script ProfileHeader
    
    private let profileHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.image = UIImage(named: <#T##String#>)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubview(profileHeaderImageView)
        
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
        
        NSLayoutConstraint.activate(profileHeaderImageViewConstraints)
        
    }

}
