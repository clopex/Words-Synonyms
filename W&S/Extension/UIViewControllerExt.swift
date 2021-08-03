//
//  UIViewControllerExt.swift
//  W&S
//
//  Created by Adis Mulabdic on 29.07.2021.
//

import UIKit

extension UIViewController : StoryboardIdentifiable {
    var activityIndicatorTag: Int { return 999999 }
    
    func startActivityIndicator(style: UIActivityIndicatorView.Style = .large, location: CGPoint? = nil, color: UIColor = .white) {
        
        let loc = location ?? self.view.center
        
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            let activityIndicator = UIActivityIndicatorView(style: style)
            //Add the tag so we can find the view in order to remove it later
            
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.color = color
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    func stopActivityIndicator() {
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
    
    //Show a basic alert
    func showAlertDialog(alertText: String, alertMessage: String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addGradientBg() {
        view.setGradientBackground(.topBgColor, .bottomBgColor)
    }
}
