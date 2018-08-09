//
//  AppDelegate.swift
//  thinkMargin
//
//  Created by Ahmed ElSenousi on 20/09/2015.
//  Copyright © 2015 Ahmed ElSenousi. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GADBannerViewDelegate {

    var window: UIWindow?
    var bannerView: GADBannerView!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UITabBarController()
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        
        let priceView: priceViewController = priceViewController()
        let marginView: marginViewController = marginViewController()
        let costView: costViewController = costViewController()
        
        (self.window?.rootViewController as? UITabBarController)?.setViewControllers([priceView, marginView, costView], animated: true)
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = ""
        bannerView.rootViewController = self.window?.rootViewController
        bannerView.delegate = self
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        bannerView.loadRequest(request)

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
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        self.window?.rootViewController?.view.addSubview(bannerView)
    }


}

