//
//  MainViewController.swift
//  LoveFreshBee
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  GitHub地址:https://github.com/ZhongTaoTian/LoveFreshBeen
//  Blog讲解地址:http://www.jianshu.com/p/879f58fe3542
//  swift改版到3.0 https://www.jianshu.com/p/32c0712f529f

import UIKit

class MainTabBarController: AnimationTabBarController, UITabBarControllerDelegate {
    
    fileprivate var fristLoadMainTabBarController: Bool = true
    fileprivate var adImageView: UIImageView?
    //获取d启动页的图片，实现淡入淡出效果
    var adImage: UIImage? {
        didSet {
            weak var tmpSelf = self
            adImageView = UIImageView(frame: ScreenBounds)
            adImageView!.image = adImage!
            self.view.addSubview(adImageView!)
            
            UIImageView.animate(withDuration: 2.0, animations: { () -> Void in
                tmpSelf!.adImageView!.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                tmpSelf!.adImageView!.alpha = 0
                }, completion: { (finsch) -> Void in
                    tmpSelf!.adImageView!.removeFromSuperview()
                    tmpSelf!.adImageView = nil
            }) 
        }
    }
    
// MARK:- view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        buildMainTabBarChildViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)  //如果true，使用动画将视图添加到窗口中。

        if fristLoadMainTabBarController {
            let containers = createViewContainers()  //建立视图容器
            
            createCustomIcons(containers)
            fristLoadMainTabBarController = false
        }
    }

    
    
        //MARK: - 初始化tabbar
    
//    最后MainTabBarController继承AnimationTabBarController
//    
//    调用createViewContainers也就是父类中的方法
//    
//    并且给tabBarController添加视图控制器
    

    
// MARK: - Method
    // MARK: 初始化tabbar
    fileprivate func buildMainTabBarChildViewController() {
        tabBarControllerAddChildViewController(HomeViewController(), title: "首页", imageName: "v2_home", selectedImageName: "v2_home_r", tag: 0)
        tabBarControllerAddChildViewController(SupermarketViewController(), title: "闪电超市", imageName: "v2_order", selectedImageName: "v2_order_r", tag: 1)
        tabBarControllerAddChildViewController(ShopCartViewController(), title: "购物车", imageName: "shopCart", selectedImageName: "shopCart", tag: 2)
        tabBarControllerAddChildViewController(MineViewController(), title: "我的", imageName: "v2_my", selectedImageName: "v2_my_r", tag: 3)
    }
    
    fileprivate func tabBarControllerAddChildViewController(_ childView: UIViewController, title: String, imageName: String, selectedImageName: String, tag: Int) {
        
        let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        
        vcItem.tag = tag  //UIBarItem--> var tag ==0 紫色是系统变量
        
        vcItem.animation = RAMBounceAnimation()
        childView.tabBarItem = vcItem
        
//        childView.tabBarItem.tag = tag    //测试消除动画效果
//        childView.tabBarItem.title = title
//        childView.tabBarItem.image = UIImage(named: imageName)
//        childView.tabBarItem.selectedImage = UIImage(named: selectedImageName)
//
        
        
        let navigationVC = BaseNavigationController(rootViewController:childView)
        addChildViewController(navigationVC)
    }
    
    //UITabBarControllerDelegate ->代理方法
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let childArr = tabBarController.childViewControllers as NSArray
        let index = childArr.index(of: viewController)
        
        //购物车页面拦截
        if index == 2 {
            return false
        }
        
        return true
    }
}


