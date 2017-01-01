//
//  TtroAlertViewController.swift
//  RadiusBlurMenu
//
//  Created by Farid on 8/12/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import EasyPeasy
import PayWandBasicElements


public protocol TtroAlertViewControllerDelegate : TtroAlertViewControllerTransitionAnimationDelegate {
    func getFrontView() -> UIView
}

public class TtroAlertViewController: UIViewController {
    
    let showTransitionAnimation = TtroAlertViewControllerShowTransitionAnimation()
    let dismissTransitionAnimation = TtroAlertViewControllerDismissTransitionAnimation()
    
    
    var frontView : UIView!
    
    var alertPage : UIView!
    
    var page : TtroAlertPage!
    var pageCopy : TtroAlertPage!
    
    let r : CGFloat = 120 - 2
    let alpha : CGFloat = 0.91
    
    let h : CGFloat = 220
    var w : CGFloat {
        get {
            return 2 * r * sin(alpha)
        }
    }
    
    var center : CGPoint {
        get {
            return CGPoint(x : view.center.x, y : view.center.y)
        }
    }
    
    var origin : CGPoint {
        get {
            return CGPoint(x: center.x - w/2, y: center.y + r * cos(alpha) - h)
        }
    }
    
    var alertPageYConstraint : NSLayoutConstraint!
    public var delegate : TtroAlertViewControllerDelegate!
    var message : String!
    var type = TtroAlertType.okAlert
    
    
    public convenience init(title : String, message : String, type : TtroAlertType) {
        self.init(nibName : nil, bundle : nil )
        
        self.type = type
        self.title = title
        self.message = message
        
        transitioningDelegate = self
        showTransitionAnimation.delegate = self
        self.modalPresentationStyle = .overCurrentContext
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        frontView = delegate.getFrontView()
        print(frontView.frame)
        frontView.backgroundColor = UIColor.orange
        initElements(title!, message: message, type: type)
    }
    
    func initElements(_ title : String, message : String, type : TtroAlertType){
        
        let backBlurView = APCustomBlurView(withRadius: 2)
        backBlurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBlurView)
        backBlurView <- Edges()
        
        let r2 = r + 1
        
        let alertBackCircle = UIView()
        alertBackCircle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertBackCircle)
        alertBackCircle <- [
            Center(),
            Width(2*(r2)),
            Height().like(alertBackCircle , .width)
        ]
        alertBackCircle.layer.cornerRadius = r2
        alertBackCircle.layer.borderWidth = 2
        alertBackCircle.layer.borderColor = UIColor.TtroColors.white.color.cgColor
        alertBackCircle.backgroundColor = UIColor.TtroColors.darkBlue.color.withAlphaComponent(0.7)
        
        view.addSubview(frontView)
        view.layoutIfNeeded()
        
        let maskShape = CAShapeLayer()
        maskShape.path = getCanvasPath(view.center, r: r, h: h, alpha: alpha)
        maskShape.fillRule = kCAFillRuleEvenOdd;
        frontView.layer.mask = maskShape
        
        /// custom blur
        
        let blurView = APCustomBlurView(withRadius: 2)
        //blurView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        //blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        blurView <- Edges()
        let maskShape3 = CAShapeLayer()
        maskShape3.path = getCanvasPath(view.center, r: r, h: h, alpha: alpha)
        maskShape3.fillRule = kCAFillRuleEvenOdd;
        //blurView.layer.mask = maskShape3
        
        let maskView = UIView(frame: view.frame)
        maskView.backgroundColor = UIColor.black
        maskView.layer.mask = maskShape3
        blurView.mask = maskView
        
        
        
        let alertCircle = UIView()
        alertCircle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertCircle)
        
        alertCircle <- [
            Center(),
            Width(2*(r2)),
            Height().like(alertCircle , .width)
        ]
        alertCircle.layer.cornerRadius = r2
        alertCircle.layer.borderWidth = 2
        alertCircle.layer.borderColor = alertBackCircle.layer.borderColor
        let maskShape2 = CAShapeLayer()
        maskShape2.path = getCanvasPath(CGPoint(x: r2, y: r2), r: r, h: h, alpha: alpha)
        maskShape2.fillRule = kCAFillRuleEvenOdd
        alertCircle.layer.mask = maskShape2
        
        alertPage = UIView()
        alertPage.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(alertPage, aboveSubview: alertBackCircle)
        alertPage <- [
            CenterX(origin.x + w/2 - view.center.x),
            //CenterY(origin.y - view.center.y),
            Width(w),
            Height(2*h),
        ]
        alertPageYConstraint = alertPage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: origin.y + h - view.center.y)
        alertPageYConstraint.isActive = true
        alertPage.layer.cornerRadius = 10
        alertPage.backgroundColor = UIColor.TtroColors.white.color
        
        page = TtroAlertPage(title: title, message: message, type: type, superView: alertPage)
        setAlertPageForAnimation()
        
        view.layoutIfNeeded()
        
        switch type {
        case .okAlert:
            addAction("Ok", style: TtroAlertButtonType.default, handler: {
                self.dismiss(animated: true, completion: nil)
            })
        default:
            break
        }
        
    }
    
    func getCanvasPath(_ center : CGPoint, r : CGFloat, h : CGFloat, alpha : CGFloat) -> CGPath {
        let beta = CGFloat(M_PI)/2 - alpha
        let canvasPath = UIBezierPath.init(arcCenter: center,
                                           radius: r, startAngle: beta, endAngle: CGFloat(M_PI)/2 + alpha, clockwise: true)
        let w : CGFloat = 2 * r * sin(alpha)
        
        let origin = CGPoint(x: center.x - w/2, y: center.y + r * cos(alpha) - h)
        let size = CGSize(width: w, height: h)
        
        canvasPath.append(UIBezierPath.init(arcCenter: center,
            radius: r, startAngle: -beta, endAngle: beta, clockwise: true))
        canvasPath.append(UIBezierPath.init(arcCenter: center,
            radius: r, startAngle: CGFloat(M_PI)-beta, endAngle: CGFloat(M_PI)+beta, clockwise: true))
//        canvasPath.appendPath(UIBezierPath.init(rect: CGRect(origin: origin, size: size)))
        canvasPath.append(UIBezierPath(roundedRect: CGRect(origin: origin, size: size), byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 10.0, height: 10.0)))
        let path = UIBezierPath.init(rect: frontView.frame)
        path.append(canvasPath)
        path.usesEvenOddFillRule = true
        return path.cgPath
    }
    
    func setFrontViewMask(){
        let maskShape = CAShapeLayer()
        maskShape.path = getCanvasPath(view.center, r: r, h: h, alpha: alpha)
        maskShape.fillRule = kCAFillRuleEvenOdd;
        frontView.layer.mask = maskShape
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TtroAlertViewController : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return showTransitionAnimation
    }
    
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransitionAnimation
    }
    
    func setAlertPageForAction(){
        page.removeFromSuperview()
        view.addSubview(page)
        page <- [
            Height(h*(1.2)),
            Width().like(alertPage),
            Top().to(alertPage, .top),
            CenterX().to(alertPage),
        ]    }
    
    func setAlertPageForAnimation(){
        page.removeFromSuperview()
        alertPage.addSubview(page)
        page <- [
            Height(h*(1.2)),
            Width().like(alertPage),
            Top(),
            CenterX(),
        ]
    }
}

extension TtroAlertViewController {
    public func addAction(_ title: String, style: TtroAlertButtonType, handler: @escaping () -> Void){
        page.addAction(title, type: style, onTouch: handler)
    }
}

extension TtroAlertViewController : TtroAlertViewControllerTransitionAnimationDelegate {
    public func isPresentedOnTabbar(fromVC viewController : UIViewController) -> Bool {
        return delegate.isPresentedOnTabbar(fromVC: viewController)
    }
}
