
////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改         //
////////////////////////////////////////////////////////////////////
//  Created by 维尼的小熊 on 19/1/06.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/wshenglong/LoveFreshBeen3


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var adViewController: ADViewController?
    
    // MARK:- public方法
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)
        
        setUM()
        
        setAppSubject()
        
        addNotification()
        
        buildKeyWindow()
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Method
    fileprivate func buildKeyWindow() {
        
        window = UIWindow(frame: ScreenBounds)
        window!.makeKeyAndVisible()
        
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        
        if isFristOpen == nil {
            window?.rootViewController = GuideViewController()
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")
        } else {
            loadADRootViewController()
        }
    }
    
    func loadADRootViewController() {
        adViewController = ADViewController()
        
        weak var tmpSelf = self
        MainAD.loadADData { (data, error) -> Void in
//            if data?.data?.img_name != nil {
                let testName = "http://article.image.ihaozhuo.com//2016//12//27//14828313324038748.jpg"
                tmpSelf!.adViewController!.imageName = testName //data!.data!.img_name
//            }
            tmpSelf!.window?.rootViewController = self.adViewController
        }
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: "showMainTabbarControllerSucess:", name: NSNotification.Name(rawValue: ADImageLoadSecussed), object: nil)
        NotificationCenter.default.addObserver(self, selector: "showMainTabbarControllerFale", name: NSNotification.Name(rawValue: ADImageLoadFail), object: nil)
        NotificationCenter.default.addObserver(self, selector: "shoMainTabBarController", name: NSNotification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
    }
    
    func setUM() {
        UMSocialData.setAppKey("569f662be0f55a0efa0001cc")
        UMSocialWechatHandler.setWXAppId("wxb81a61739edd3054", appSecret: "c62eba630d950ff107e62fe08391d19d", url: "https://github.com/ZhongTaoTian")
        UMSocialQQHandler.setQQWithAppId("1105057589", appKey: "Zsc4rA9VaOjexv8z", url: "http://www.jianshu.com/users/5fe7513c7a57/latest_articles")
        UMSocialSinaSSOHandler.openNewSinaSSO(withAppKey: "1939108327", redirectURL: "http://sns.whalecloud.com/sina2/callback")
        
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToWechatSession, UMShareToQzone, UMShareToQQ, UMShareToSina, UMShareToWechatTimeline])
    }
    
    // MARK: - Action
    func showMainTabbarControllerSucess(_ noti: Notification) {
        let adImage = noti.object as! UIImage
        let mainTabBar = MainTabBarController() //淡入淡出效果
        mainTabBar.adImage = adImage
        window?.rootViewController = mainTabBar
    }
    
    func showMainTabbarControllerFale() {
        window!.rootViewController = MainTabBarController()
    }
    
    func shoMainTabBarController() {
        window!.rootViewController = MainTabBarController()
    }
    
    // MARK:- privete Method
    // MARK:主题设置
    fileprivate func setAppSubject() {
        let tabBarAppearance = UITabBar.appearance()
        //tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        let navBarnAppearance = UINavigationBar.appearance()
        navBarnAppearance.isTranslucent = false  //显示是否透明
    }
}



