//
//  AppDelegate.swift
//  Jufn@swift
//
//  Created by admin on 2019/12/14.
//  Copyright © 2019 陈俊峰. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import SwiftMessages

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let tabbar = self.setupTabbarStyle(delegate: self as? UITabBarControllerDelegate)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = tabbar
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func setupTabbarStyle(delegate:UITabBarControllerDelegate?) -> ESTabBarController {
        let tabbarController = ESTabBarController();
        tabbarController.delegate = delegate;
        tabbarController.title = "Irregularity";
        tabbarController.tabBar.shadowImage = UIImage(named: "transparent");
        tabbarController.shouldHijackHandler = {
            tabbarController, ViewController, index in
            return index == 2;
        }
        
        tabbarController.didHijackHandler = {
           [weak tabbarController] tabBarController, ViewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                let alertView = MessageView.viewFromNib(layout: .cardView);
                alertView.configureTheme(Theme.warning);
                alertView.configureDropShadow();
                alertView.configureContent(title: "WARNING", body: "NO support yet", iconText: "🤔")
                
                var warningConfig = SwiftMessages.defaultConfig;
                warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
                SwiftMessages.show(config: warningConfig, view: alertView)
            });
        }
        
        let home = ViewController()
        let listen = UIViewController()
        let play = UIViewController()
        let find = UIViewController()
        let mine = UIViewController()
        
        home.title = "首页"
        listen.title = "我听"
        play.title = "播放"
        find.title = "发现"
        mine.title = "我的"
        
        home.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: home.title, image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        listen.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: listen.title, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        play.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: play.title, image: UIImage(named: "tab_play"), selectedImage: UIImage(named: "tab_play"))
        find.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: find.title, image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        mine.tabBarItem = ESTabBarItem.init(LBFMIrregularityBasicContentView(), title: mine.title, image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        let homeNav = UINavigationController.init(rootViewController: home);
        let listenNav = UINavigationController.init(rootViewController: listen)
        let playNav = UINavigationController.init(rootViewController: play)
        let finNav = UINavigationController.init(rootViewController: find)
        let meNav = UINavigationController.init(rootViewController: mine)
        
        tabbarController.viewControllers = [homeNav, listenNav, playNav, finNav, meNav];
        
        
        return tabbarController;
    }
}

