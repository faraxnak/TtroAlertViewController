//
//  TtroAlertPage.swift
//  RadiusBlurMenu
//
//  Created by Farid on 8/12/16.
//  Copyright © 2016 Farid. All rights reserved.
//

import UIKit
import EasyPeasy
import PayWandBasicElements

public enum TtroAlertType {
    case alert
    case okAlert
    case action
}

public enum TtroAlertButtonType {
    case `default`
    case cancel
}

class TtroAlertPage: UIView {
    
    
    
    var titleLabel : UILabel!
    var messageLabel : UILabel!
    
    var stackView : UIStackView!
    var firstButtonInView : Bool = true
    
    convenience init(title : String, message : String, type : TtroAlertType, superView : UIView, constraintView : UIView? = nil) {
        self.init(frame : CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        if let cv = constraintView {
            self <- [
                Width().like(cv),
                Top().to(cv, .top),
                CenterX().to(cv),
            ]
        } else {
            self <- [
                Width().like(superView),
                Top(),
                CenterX(),
            ]
        }
        
        initElements(title, message: message)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initElements(_ title : String, message : String){
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView <- Edges()
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        
        layoutIfNeeded()
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        stackView.addArrangedSubview(titleLabel)
        titleLabel.textColor = UIColor.TtroColors.darkBlue.color
        titleLabel.font = UIFont.TtroFonts.regular(size: 20).font
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel <- [
            Width(*0.9).like(stackView)
        ]
//        titleLabel <- [
//            Height(*0.2).like(self)
//        ]
        
        messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 5
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textColor = UIColor.TtroColors.darkBlue.color.withAlphaComponent(0.7)
        messageLabel.font = UIFont.TtroFonts.light(size: 20).font
        messageLabel.baselineAdjustment = .alignCenters
        stackView.addArrangedSubview(messageLabel)
        messageLabel <- [
            Width(*0.9).like(stackView)
        ]
        messageLabel.adjustsFontSizeToFitWidth = true
        
        messageLabel.text = message
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .justified
//        paragraphStyle.firstLineHeadIndent = 0.001
//        let mutableAttrStr = NSMutableAttributedString(attributedString: messageLabel.attributedText!)
//        mutableAttrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
//        messageLabel.attributedText = mutableAttrStr
    }
    
    func addAction(_ title : String, type : TtroAlertButtonType, onTouch : @escaping () -> Void){
        let button = TtroAlertButton(type: .custom)
        button.setTitle(title, for: UIControlState())
        button.actionHandle(controlEvents: .touchUpInside, ForAction: onTouch)
        button.setTitleColor(UIColor.TtroColors.lightBlue.color, for: UIControlState())
        button.titleLabel?.font = UIFont.TtroPayWandFonts.light3.font
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
//        if (firstButtonInView){
//            addSeparator()
//            firstButtonInView = false
//        }
        addSeparator()
        stackView.addArrangedSubview(button)
        
        button <- [
            Height(*0.2).like(self),
            Width().like(stackView)
        ]
        
        
    }
    
    fileprivate func addSeparator(){
        let lineView = UIView()
        lineView.backgroundColor = UIColor.TtroColors.darkBlue.color.withAlphaComponent(0.2)
        stackView.addArrangedSubview(lineView)
        lineView <- [
            Height(0.5),
            Width().like(stackView)
        ]
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if (alpha != 0){
            return super.hitTest(point, with: event)
        } else {
            return self
        }
    }

}

