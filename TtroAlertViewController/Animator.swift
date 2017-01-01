//
//  Animator.swift
//  TtroAlertViewController
//
//  Created by Farid on 12/28/16.
//  Copyright © 2016 ParsPay. All rights reserved.
//

import UIKit

protocol TtroAlertViewControllerTransitionAnimationDelegate : class {
    func isPresentedOnTabbar(fromVC viewController : UIViewController) -> Bool
}

class TtroAlertViewControllerShowTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    var delegate : TtroAlertViewControllerTransitionAnimationDelegate!
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? TtroAlertViewController else {
                return
        }
        let containerView = transitionContext.containerView
        //2
        let bounds = UIScreen.main.bounds
        print(fromVC)
        if delegate.isPresentedOnTabbar(fromVC: fromVC) {
            toVC.setFrontViewMask()
        }
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
            
            toVC.setAlertPageForAction()
            //toVC.alertPage.hidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}

class TtroAlertViewControllerDismissTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? TtroAlertViewController,
            let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
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
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
