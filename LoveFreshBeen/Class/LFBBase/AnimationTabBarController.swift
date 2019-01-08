//
//  AnimationTabBarController.Swift
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//  框架介绍:https://www.jianshu.com/p/e5649029ea5f
// 资料2 https://www.jianshu.com/p/58e1ca0389db
// CAKeyframeAnimation参数 https://www.jianshu.com/p/1d735e981f55

import UIKit

//3.继承自RAMItemAnimation的类,主要实现父类中的协议方法,具体设置textLabel和UIImageView的动画周期和效果
class RAMBounceAnimation : RAMItemAnimation {
    
    override func playAnimation(_ icon : UIImageView, textLabel : UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }
    
    override func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        textLabel.textColor = defaultTextColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysOriginal)
            icon.image = renderImage
            icon.tintColor = defaultTextColor
            
        }
    }
    
    override func selectedState(_ icon : UIImageView, textLabel : UILabel) {
        textLabel.textColor = textSelectedColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysOriginal)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }
    
    func playBounceAnimation(_ icon : UIImageView) {
        //动画 transform.scale 所有方向缩放
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysOriginal)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
    }
    
}

//4.自定义UITabBarItem,声明UITabBarItem中的func deselectAnimation(icon: UIImageView, textLabel: UILabel)和    func selectedState(icon:UIImageView, textLabel:UILabel)  方法,以便在自定义UITabBarController中使用,其中animation是继承的RAMItemAnimation,可以调用父类中的方法,也就是父类中提前已经声明好的几个动画函数
class RAMAnimatedTabBarItem: UITabBarItem {
    
    var animation: RAMItemAnimation?
    
    var textColor = UIColor.gray
    
    //闭包
    func playAnimation(_ icon: UIImageView, textLabel: UILabel){
        guard let animation = animation else {
            print("add animation in UITabBarItem")
            return
        }
        animation.playAnimation(icon, textLabel: textLabel)
        // RAMItemAnimation.playAnimation
    }
    
    func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
        animation?.deselectAnimation(icon, textLabel: textLabel, defaultTextColor: textColor)
    }
    
    func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        animation?.selectedState(icon, textLabel: textLabel)
    }
}

//1.这是声明了一个选择TabBarItem时动画的协议
protocol RAMItemAnimationProtocol {
    
    func playAnimation(_ icon : UIImageView, textLabel : UILabel)
    func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor)
    func selectedState(_ icon : UIImageView, textLabel : UILabel)
}


//2.遵守动画协议创建的动画类,主要是设置动画周期,item中选择的颜色
class RAMItemAnimation: NSObject, RAMItemAnimationProtocol {
    
    var duration : CGFloat = 0.6
    var textSelectedColor: UIColor = UIColor.gray
    var iconSelectedColor: UIColor?
    
    func playAnimation(_ icon : UIImageView, textLabel : UILabel) {
    }
    
    func deselectAnimation(_ icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        
    }
    
    func selectedState(_ icon: UIImageView, textLabel : UILabel) {
    }
    
}


class AnimationTabBarController: UITabBarController {
    
    var iconsView: [(icon: UIImageView, textLabel: UILabel)] = []
    var iconsImageName:[String] = ["v2_home", "v2_order", "shopCart", "v2_my"]
    var iconsSelectedImageName:[String] = ["v2_home_r", "v2_order_r", "shopCart_r", "v2_my_r"]
    var shopCarIcon: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: "searchViewControllerDeinit", name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func searchViewControllerDeinit() {
        //搜索页面析构时判断购物车红点状态
        if shopCarIcon != nil {
            let redDotView = ShopCarRedDotView.sharedRedDotView
            redDotView.frame = CGRect(x: 21 + 1, y: -3, width: 15, height: 15)
            shopCarIcon?.addSubview(redDotView)
        }
    }
    
    //创建承载TabBarItem的视图容器,里面是item中的titleLabel和UIImageView,将视图容器存入字典,以便在后续使用中可以分清是点了哪一个item
    func createViewContainers() -> [String: UIView] {
        var containersDict = [String: UIView]()
        //tabbar的item是继承的自定义的RAMAnimatedTabBarItem,其中包含了动画设置的函数
        guard let customItems = tabBar.items as? [RAMAnimatedTabBarItem] else
        {
            return containersDict
        }
        
        //根据item的个数创建视图容器,将视图容器放在字典中
        for index in 0..<customItems.count {
            let viewContainer = createViewContainer(index)
            containersDict["container\(index)"] = viewContainer
        }
        
        return containersDict
    }
    
    //根据index值创建每个的视图容器
    func createViewContainer(_ index: Int) -> UIView {
        // 建立容器视图位置
        
        /// 底部tabBar的高度
        let viewWidth: CGFloat = ScreenWidth / CGFloat(tabBar.items!.count)
        let viewHeight: CGFloat = tabBar.bounds.size.height
        
        let viewContainer = UIView(frame: CGRect(x: viewWidth * CGFloat(index), y: 0, width: viewWidth, height: viewHeight))
        
        viewContainer.backgroundColor = UIColor.clear
        viewContainer.isUserInteractionEnabled = true // 设置视图的可交互性
        
        tabBar.addSubview(viewContainer)
        viewContainer.tag = index
        
        //给容器添加手势,其实是自己重写了系统的item的功能,因为我们要在里面加入动画
        let tap = UITapGestureRecognizer(target: self, action: Selector(("tabBarClick:")))
        viewContainer.addGestureRecognizer(tap)
        
        return viewContainer
    }
    
    //创建items的具体内容
    func createCustomIcons(_ containers : [String: UIView]) {
        if let items = tabBar.items {
            
            for (index, item) in items.enumerated() {
                
                assert(item.image != nil, "add image icon in UITabBarItem")
                
                guard let container = containers["container\(index)"] else
                {
                    print("No container given")
                    continue
                }
                
                container.tag = index
                
                let imageW:CGFloat = 21
                let imageX:CGFloat = (ScreenWidth / CGFloat(items.count) - imageW) * 0.5
                let imageY:CGFloat = 8
                let imageH:CGFloat = 21
                let icon = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageW, height: imageH))
                icon.image = item.image
                icon.tintColor = UIColor.clear
                
                
                // text
                let textLabel = UILabel()
                textLabel.frame = CGRect(x: 0, y: 32, width: ScreenWidth / CGFloat(items.count), height: 49 - 32)
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clear
                textLabel.font = UIFont.systemFont(ofSize: 10)
                textLabel.textAlignment = NSTextAlignment.center
                textLabel.textColor = UIColor.gray
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(icon)
                container.addSubview(textLabel)
                
                
                if let tabBarItem = tabBar.items {
                    let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBarItem.count)
                    textLabel.bounds.size.width = textLabelWidth
                }
                
                if 2 == index {
                    let redDotView = ShopCarRedDotView.sharedRedDotView
                    redDotView.frame = CGRect(x: imageH + 1, y: -3, width: 15, height: 15)
                    icon.addSubview(redDotView)
                    shopCarIcon = icon
                }
                
                let iconsAndLabels = (icon:icon, textLabel:textLabel)
                iconsView.append(iconsAndLabels)
                
            
                item.image = nil
                item.title = ""
                
                if index == 0 {
                    selectedIndex = 0
                    selectItem(0)
                }
            }
        }
    }
    
    //选择时触发动画
    //重写父类的didSelectItem
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
         setSelectIndex(from: selectedIndex, to: item.tag)
       
    }
    
    //选择item时item中内容的变化
    func selectItem(_ Index: Int) {
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        let selectIcon = iconsView[Index].icon
        selectIcon.image = UIImage(named: iconsSelectedImageName[Index])!
        items[Index].selectedState(selectIcon, textLabel: iconsView[Index].textLabel)
    }
    
    // h实现页面 传递参数给动画
    //根据选择的index值设置item中的内容并且执行动画父类中的方法
    func setSelectIndex(from: Int,to: Int) {
        
        if to == 2 {
            let vc = childViewControllers[selectedIndex]
            let shopCar = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCar)
            vc.present(nav, animated: true, completion: nil)
            
            return
        }
        
        selectedIndex = to
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        
        let fromIV = iconsView[from].icon
        fromIV.image = UIImage(named: iconsImageName[from])
        items[from].deselectAnimation(fromIV, textLabel: iconsView[from].textLabel)
        
        let toIV = iconsView[to].icon
        toIV.image = UIImage(named: iconsSelectedImageName[to])
        items[to].playAnimation(toIV, textLabel: iconsView[to].textLabel)
    }
}
