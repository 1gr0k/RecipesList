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
    let notifications = Notifications()
    
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register \(error)")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let resultId = RouteParser(route: url.absoluteString)
        showDetailPageByResultOfParsing(result: resultId)
        return true
    }
    
    func showDetailPageByResultOfParsing(result: RouteParser) {
        switch result {
        case .recipe(let string):
            appFlowCoordinator?.openDetail(id: string)
        case .error:
            print("error")
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        let resultId = RouteParser(route: aps["recipe_link"] as! String)
        showDetailPageByResultOfParsing(result: resultId)
    }
}
