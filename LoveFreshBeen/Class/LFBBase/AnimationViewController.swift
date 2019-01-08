//
//  AnimationViewController.swift
//  LoveFreshBeen
//
//  Created by 维尼的小熊 on 16/1/12.
//  Copyright © 2016年 tianzhongtao. All rights reserved.
//MARK: - animationDidStop()方法未实现

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AnimationViewController: BaseViewController,CAAnimationDelegate {
    
    var animationLayers: [CALayer]?
    
    var animationBigLayers: [CALayer]?
    
    // MARK: 商品添加到购物车动画
    func addProductsAnimation(_ imageView: UIImageView) {
        
        if (self.animationLayers == nil)
        {
            self.animationLayers = [CALayer]();
        }
        
        let frame = imageView.convert(imageView.bounds, to: view)
        let transitionLayer = CALayer()
        transitionLayer.frame = frame
        transitionLayer.contents = imageView.layer.contents
        //MARK: 这里被注销掉
        self.view.layer.addSublayer(transitionLayer)
        self.animationLayers?.append(transitionLayer)
        
        let p1 = transitionLayer.position;
        let p3 = CGPoint(x: view.width - view.width / 4 - view.width / 8 - 6, y: self.view.layer.bounds.size.height - 40);
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let path = CGMutablePath();
        path.move(to: p1)
        path.addCurve(to: CGPoint(x: p1.x,y:p1.y - 30), control1: CGPoint(x: p3.x,y: p1.y - 30), control2: p3)
        positionAnimation.path = path;
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.9
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = true
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1))
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, transformAnimation, opacityAnimation];
        groupAnimation.duration = 0.8
        //MARK: -这里代理不起作用
        groupAnimation.delegate = self as? CAAnimationDelegate;
        //解决动画重复问题？
        
        transitionLayer.add(groupAnimation, forKey: "cartParabola")
      
    }
    

    // MARK: - 添加商品到右下角购物车动画
    func addProductsToBigShopCarAnimation(_ imageView: UIImageView) {
        if animationBigLayers == nil {
            animationBigLayers = [CALayer]()
        }
  
        let frame = imageView.convert(imageView.bounds, to: view)
        let transitionLayer = CALayer()
        transitionLayer.frame = frame
        transitionLayer.contents = imageView.layer.contents
        self.view.layer.addSublayer(transitionLayer)
        self.animationBigLayers?.append(transitionLayer)
        
        let p1 = transitionLayer.position;
        let p3 = CGPoint(x: view.width - 40, y: self.view.layer.bounds.size.height - 40);
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let path = CGMutablePath();
        path.move(to: p1)
        path.addCurve(to: CGPoint(x: p1.x,y:p1.y - 30), control1: CGPoint(x: p3.x,y: p1.y - 30), control2: p3)
//        CGPathAddCurveToPoint(path, &transform, p1.x, p1.y - 30, p3.x, p1.y - 30, p3.x, p3.y);
        positionAnimation.path = path;
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.9
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = true
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1))
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, transformAnimation, opacityAnimation];
        groupAnimation.duration = 0.8
//        groupAnimation.delegate = self;
        
        transitionLayer.add(groupAnimation, forKey: "BigShopCarAnimation")
    }
     //animationDidStop是CAAnimationDelegate里面的方法
    // func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        if self.animationLayers?.count > 0 {
            let transitionLayer = animationLayers![0]
            transitionLayer.isHidden = true
            transitionLayer.removeFromSuperlayer()
            animationLayers?.removeFirst()
            view.layer.removeAnimation(forKey: "cartParabola")
        }
        
        if self.animationBigLayers?.count > 0 {
            let transitionLayer = animationBigLayers![0]
            transitionLayer.isHidden = true
            transitionLayer.removeFromSuperlayer()
            animationBigLayers?.removeFirst()
            view.layer.removeAnimation(forKey: "BigShopCarAnimation")
        }
    }
}
