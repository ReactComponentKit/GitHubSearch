//
//  UIView+RxTab.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIView {
    fileprivate func runRiffleEffect(hitPoint : CGPoint) {
        let rippleEffectLayer = CALayer()
        
        rippleEffectLayer.frame = CGRect(x:hitPoint.x - 5, y:hitPoint.y - 5, width:5, height:5)
        rippleEffectLayer.cornerRadius = rippleEffectLayer.frame.height / 2
        rippleEffectLayer.masksToBounds = true;
        rippleEffectLayer.backgroundColor = UIColor(white: 0.8, alpha: 0.4).cgColor
        rippleEffectLayer.zPosition = 1.0
        self.layer.addSublayer(rippleEffectLayer)
        
        let maxSize = max(rippleEffectLayer.superlayer!.frame.width, rippleEffectLayer.superlayer!.frame.width)
        let minSize = min(rippleEffectLayer.frame.width, rippleEffectLayer.frame.height)
        let scaleRate = (maxSize / minSize) * 2 * 1.42
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            rippleEffectLayer.removeFromSuperlayer()
        }
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(scaleRate, scaleRate, 1))
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        colorAnimation.toValue = UIColor.clear.cgColor
        
        group.animations = [scaleAnimation, colorAnimation]
        
        rippleEffectLayer.add(group, forKey: "all")
        
        CATransaction.commit()
    }
    
    func onTap(action: @escaping () -> Swift.Void) -> Disposable {
        
        self.layer.masksToBounds = true
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        
        return tap.rx.event.asDriver().drive(onNext: { [weak self] (recognizer) in
            guard let strongSelf = self else { return }

            let hitPoint = recognizer.location(in: strongSelf)
            strongSelf.runRiffleEffect(hitPoint: hitPoint)
            
            if recognizer.state == .ended {
                action()
            }
        })
    }
}
