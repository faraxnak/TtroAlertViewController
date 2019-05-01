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

public enum TTroAlertState {
    case error
    case success
    case warning
}

class TtroAlertPage: UIView {
    
    fileprivate var titleLabel : UILabel!
    fileprivate var messageLabel : UILabel!
    
    fileprivate var stackView : UIStackView!
    var firstButtonInView : Bool = true
    
    convenience init(message : String, type : TtroAlertType, state : TTroAlertState, superView : UIView, constraintView : UIView? = nil) {
        self.init(frame : CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        if let cv = constraintView {
            self.easy.layout([
                Width().like(cv),
                Top().to(cv, .top),
                CenterX().to(cv),
            ])
        } else {
            self.easy.layout([
                Width().like(superView),
                Top(),
                CenterX(),
            ])
        }
        
        initElements(state, message: message)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initElements(_ state : TTroAlertState, message : String){
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.easy.layout([
            Top(10),
            Left(),
            Right(),
            Bottom()
            ])
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        
        let dummyView = UIView()
        dummyView.easy.layout(Height(15))
        stackView.addArrangedSubview(dummyView)
        
        var icon : UIImage?
        switch state {
        case .error:
            icon = #imageLiteral(resourceName: "alertBoxError")
        case .success:
            icon = #imageLiteral(resourceName: "alertBoxConfirm")
        case .warning:
            icon = #imageLiteral(resourceName: "alertBoxWarning")
        }
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.easy.layout([
            Height(45)
            ])
        stackView.addArrangedSubview(iconView)
        
//        titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 2
//        titleLabel.lineBreakMode = .byWordWrapping
//        stackView.addArrangedSubview(titleLabel)
//        titleLabel.textColor = UIColor.TtroColors.darkBlue.color
//        titleLabel.font = UIFont.TtroPayWandFonts.regular2.font
//        titleLabel.baselineAdjustment = .alignCenters
//        titleLabel.easy.layout([
//            Width(*0.9).like(stackView)
//        ])
////        titleLabel.text = title
//        let paragraphStyle1 = NSMutableParagraphStyle()
//        paragraphStyle1.lineSpacing = 5 // Whatever line spacing you want in points
//        paragraphStyle1.alignment = .center
//        let text1 = NSAttributedString(string: title,
//                                      attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle1])
//        //            amountInUserCurrencyLabel.text = amountInUserCurrencyString
//        titleLabel.attributedText = text1

//        titleLabel <- [
//            Height(*0.2).like(self)
//        ]
        
        messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 5
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textColor = UIColor.TtroColors.darkBlue.color.withAlphaComponent(0.7)
        messageLabel.font = UIFont.TtroPayWandFonts.light2.font
        messageLabel.baselineAdjustment = .alignCenters
        stackView.addArrangedSubview(messageLabel)
        messageLabel.easy.layout([
            Width(*0.9).like(stackView)
        ])
        messageLabel.adjustsFontSizeToFitWidth = true
        
//        messageLabel.text = message
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
        paragraphStyle.alignment = .center
        let text = NSAttributedString(string: message,
                                      attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
        //            amountInUserCurrencyLabel.text = amountInUserCurrencyString
        messageLabel.attributedText = text
        
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
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
//        if (firstButtonInView){
//            addSeparator()
//            firstButtonInView = false
//        }
        addSeparator()
        stackView.addArrangedSubview(button)
        
        button.easy.layout([
            Height(*0.2).like(self),
            Width().like(stackView)
        ])
        
        
    }
    
    fileprivate func addSeparator(){
        let lineView = UIView()
        lineView.backgroundColor = UIColor.TtroColors.darkBlue.color.withAlphaComponent(0.2)
        stackView.addArrangedSubview(lineView)
        lineView.easy.layout([
            Height(0.5),
            Width().like(stackView)
        ])
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

