//
//  ViewController.swift
//  email Practice
//
//  Created by Tariq Almazyad on 6/2/20.
//  Copyright © 2020 ARMobileApps. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureViewControllers()
    }
    
    func configureViewControllers(){

        let eventVC = constructTabBarController(unselectedImage: #imageLiteral(resourceName: "event"),
                                                selectedImage: #imageLiteral(resourceName: "event"),
                                                rootViewController: EventVC(collectionViewLayout: UICollectionViewFlowLayout()))
        eventVC.title = "Events"
        
        let feedBackVC = constructTabBarController(unselectedImage: #imageLiteral(resourceName: "feedback"),
                                                   selectedImage: #imageLiteral(resourceName: "feedback"),
                                                   rootViewController: FeedBackVC())
        feedBackVC.title = "FeedBack"
        viewControllers = [eventVC, feedBackVC]
        tabBar.tintColor = .black
        tabBar.barStyle = .default
        tabBar.isTranslucent = true
    }
    
    func constructTabBarController(unselectedImage: UIImage,
                                   selectedImage: UIImage,
                                   rootViewController : UIViewController = UIViewController()) -> UINavigationController{
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }


}

