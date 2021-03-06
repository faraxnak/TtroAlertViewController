//
//  Animator.swift
//  TtroAlertViewController
//
//  Created by Farid on 12/28/16.
//  Copyright © 2016 ParsPay. All rights reserved.
//

import UIKit

public protocol TtroAlertViewControllerTransitionAnimationDelegate : class {
    func isPresentedOnTabbar(fromVC viewController : UIViewController) -> Bool
}

public class TtroAlertViewControllerShowTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    var delegate : TtroAlertViewControllerTransitionAnimationDelegate!
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? TtroAlertViewController else {
                return
        }
        let containerView = transitionContext.containerView
        //2
        let bounds = UIScreen.main.bounds
        print(fromVC)
        if delegate == nil {
            delegate = toVC
        }
//        if delegate.isPresentedOnTabbar(fromVC: fromVC) {
//            toVC.setFrontViewMask()
//        }
        toVC.setFrontViewMask()
        containerView.addSubview(toVC.view)
        toVC.alertPageYConstraint.constant += bounds.size.height
        
        //3
        let duration = transitionDuration(using: transitionContext)
        containerView.layoutIfNeeded()
        
        //4
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            toVC.alertPageYConstraint.constant -= bounds.size.height
            toVC.view.layoutIfNeeded()
            containerView.layoutIfNeeded()
        }, completion: {
            finished in
            
//            containerView.addSubview(toVC.view)
            toVC.setAlertPageForAction()
            //toVC.alertPage.hidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            containerView.insertSubview(fromVC.view, belowSubview: toVC.view)
        })
        
    }
}

public class TtroAlertViewControllerDismissTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? TtroAlertViewController,
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let containerView = transitionContext.containerView
        //2
        let bounds = UIScreen.main.bounds
        
        fromVC.setAlertPageForAnimation()
        
        //3
        let duration = transitionDuration(using: transitionContext)
        containerView.layoutIfNeeded()
        
        //4
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            fromVC.alertPageYConstraint.constant += bounds.size.height
            containerView.layoutIfNeeded()
        }) { (finished) in
            containerView.addSubview(toVC.view)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
