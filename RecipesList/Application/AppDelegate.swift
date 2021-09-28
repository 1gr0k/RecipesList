//
//  AppDelegate.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import UIKit
import CoreData
import Swinject
import InjectPropertyWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let container = Container()
    
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppAppearance.setupAppearance()
        
        InjectSettings.resolver = AppDelegate.container
        
        AppDelegate.container.registerAllInjections()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        appFlowCoordinator = AppFlowCoordinator(window: window!)
        appFlowCoordinator?.start()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
    }
}

