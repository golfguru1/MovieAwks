//
//  AppDelegate.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase
import Alamofire
import CRToast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var manager: NetworkReachabilityManager?
    var wasPreviousSame = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        FIRApp.configure()
        
        var options = [
            kCRToastNotificationTypeKey: CRToastType.Custom.rawValue,
            kCRToastNotificationPreferredHeightKey: 24,
            kCRToastTextAlignmentKey : NSTextAlignment.Center.rawValue,
            kCRToastAnimationInTypeKey : CRToastAnimationType.Gravity.rawValue,
            kCRToastAnimationOutTypeKey : CRToastAnimationType.Gravity.rawValue,
            kCRToastAnimationInDirectionKey : CRToastAnimationDirection.Top.rawValue,
            kCRToastAnimationOutDirectionKey : CRToastAnimationDirection.Top.rawValue,
            kCRToastFontKey: UIFont(name: "Futura", size: 14)!,
            ] as [String: AnyObject]
        
        
        manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            var showNotification = true
            switch status {
            case .NotReachable:
                options[kCRToastTextKey] = "internet not reachable"
                options[kCRToastBackgroundColorKey] = UIColor.redColor()
                self.wasPreviousSame = false
                showNotification = true
                break
            case .Unknown:
                options[kCRToastTextKey] = "internet connection unknown"
                options[kCRToastBackgroundColorKey] = UIColor.yellowColor()
                self.wasPreviousSame = false
                showNotification = true
                break
            case .Reachable(.EthernetOrWiFi), .Reachable(.WWAN):
                options[kCRToastTextKey] = "connected to internet"
                options[kCRToastBackgroundColorKey] = UIColor.greenColor()
                if self.wasPreviousSame{
                    self.wasPreviousSame = true
                    showNotification = false
                }
                else{
                    self.wasPreviousSame = true
                    showNotification = true
                }
                break
                
            }
            if showNotification {
                CRToastManager.showNotificationWithOptions(options, completionBlock: nil)
            }
        }
        
        manager?.startListening()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

