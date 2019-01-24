//
//  AppDelegate.swift
//  FlintDemo
//
//  Created by Marc Palmer on 06/02/2018.
//  Copyright © 2018 Montana Floss Co. Ltd. All rights reserved.
//

import UIKit
import FlintCore
import FlintUI
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    var presentationRouter: SimplePresentationRouter!

    /// - Tag: flint-bootstrapping
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Flint.quickSetup(AppFeatures.self, domains: ["mysite.com"], initialDebugLogLevel: .debug)
        Flint.register(group: FlintUIFeatures.self)
        
        // Override point for customization after application launch.
        let splitViewController = window!.rootViewController as! UISplitViewController
        let primaryNavigationController = splitViewController.viewControllers.first as! UINavigationController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        
        presentationRouter = SimplePresentationRouter(navigationController: primaryNavigationController)
        
        if let firstDocumentInfo = DocumentStore.shared.listDocuments().first {
            if let firstDocument = DocumentStore.shared.load(firstDocumentInfo.name) {
                SiriFeature.getNote.donateToSiri(for: firstDocument.documentRef)
            }
        }
        return true
    }
    
    // MARK: - URL and Continuity handling

    /// !!! TODO: What is this for?
    func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {

    }

    /// !!! TODO: Anything to do here?
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    /// !!! TODO: What is this for? Preventing non-enabled intents?
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        return true
    }
    
    /// - Tag: application-open-url
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        /// !!! TODO: Handle open-in-place etc. from options
        let result: MappedActionResult = Flint.open(url: url, with: presentationRouter)
        return result == .success
    }
    
    /// - Tag: application-continue-activity
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        /// !!! TODO: Need to ask if the activity is supported at all, or if the app has custom handling
        return Flint.continueActivity(activity: userActivity, with: presentationRouter) == .success
    }

    // MARK: - Lifecycle
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let _ = secondaryAsNavController.topViewController as? EmptyViewController else {
            return false
        }
        return true
    }

}

