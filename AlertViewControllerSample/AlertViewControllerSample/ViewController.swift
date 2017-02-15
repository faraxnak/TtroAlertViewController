//
//  ViewController.swift
//  AlertViewControllerSample
//
//  Created by Farid on 1/17/17.
//  Copyright © 2017 ParsPay. All rights reserved.
//

import UIKit
import EasyPeasy
import TtroAlertViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onShowAlert(_ sender: Any) {
        let alertController = createAlert(title: "Sample Alert Title", message: "This is just a test message", type: .alert)
        alertController.addAction("Do something...", style: .default, handler: { (_) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction("Ignore", style: .cancel, handler: {
            alertController.dismiss(animated: true, completion: nil)
        })
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ViewController : TtroAlertViewControllerDelegate {
    public func isPresentedOnTabbar(fromVC viewController: UIViewController) -> Bool {
        return false
    }
    
    public func getFrontView() -> UIView {
        let snapshot : UIView!
        if let tb = self.tabBarController {
            snapshot = tb.view.snapshotView(afterScreenUpdates: false)
            //snapshot.backgroundColor = UIColor.TtroColors.DarkBlue.color
        } else {
            snapshot = view.snapshotView(afterScreenUpdates: false)
        }
        return snapshot
    }
    
    func createAlert(title: String, message : String, type : TtroAlertType) -> TtroAlertViewController{
        let alertController = TtroAlertViewController(title: title, message: message, type: type)
        alertController.delegate = self
        alertController.view.layoutIfNeeded()
        return alertController
    }
}
