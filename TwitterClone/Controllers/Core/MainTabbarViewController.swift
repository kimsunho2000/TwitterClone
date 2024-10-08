//
//  ViewController.swift
//  TwitterClone
//
//  Created by 김선호 on 5/19/24.
//

import UIKit

class MainTabbarViewController : UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //Push ViewController to stack
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController(viewModel: SearchViewViewModel()))
        let vc3 = UINavigationController(rootViewController: NotificationsViewController())
        let vc4 = UINavigationController(rootViewController: DirectMessagesViewController())
       
        //Add tabBarItem referenced by SF symbols
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        vc3.tabBarItem.image = UIImage(systemName: "bell")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "bell.fill")
        
        vc4.tabBarItem.image = UIImage(systemName: "envelope")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "envelope.fill")

        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }


}

