//
//  AppDelegate.swift
//  NCMBPushPractice
//
//  Created by 井上 龍一 on 2016/03/01.
//  Copyright © 2016年 Ryuichi Inoue. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NCMB.setApplicationKey(AppKeys().ncmb.appID , clientKey: AppKeys().ncmb.clientKey)
        getDeviceToken()
        return true
    }
    
    func getDeviceToken(){
        //通知のタイプを設定したsettingを用意
        let type = UIUserNotificationType([.Alert, .Badge, .Sound])
        let setting = UIUserNotificationSettings(forTypes: type, categories: nil)
        
        let application = UIApplication.sharedApplication()
        
        //通知のタイプを設定
        application.registerUserNotificationSettings(setting)
        
        //DevoceTokenを要求
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //端末情報を扱うNCMBInstallationのインスタンスを作成
        let installation = NCMBInstallation.currentInstallation()
        
        //Device Tokenを設定
        installation.setDeviceTokenFromData(deviceToken)
        
        //端末情報をデータストアに登録
        installation.saveInBackgroundWithBlock { (error) in
            guard error == nil else {
                //端末情報の登録が失敗した場合の処理
                if error.code == 409001 {
                    //失敗した原因がdeviceTokenの重複だった場合
                    self.updateExistInstallation(installation)
                } else {
                    print("エラー：\(error.code)")
                }
                return
            }
            
            //端末情報の登録が成功した場合の処理
            print("端末情報登録に成功")
        }
    }
    
    func updateExistInstallation(currentInstallation: NCMBInstallation) {
        let installationQuery = NCMBInstallation.query()
        installationQuery.whereKey("deviceToken", equalTo: currentInstallation.deviceToken)
        
        do {
            let searchDevice = try installationQuery.getFirstObject()
            currentInstallation.objectId = searchDevice.objectId
            //上書き保存する
            currentInstallation.saveInBackgroundWithBlock{ (error) -> Void in
                guard error == nil else {
                    print("端末情報更新に失敗")
                    return
                }
                print("端末情報更新に成功")
            }
        } catch {
            print("端末情報検索に失敗")
        }
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

