//
//  Utils.swift
//  AppTouchTask
//
//  Created by Vijay K on 12/12/22.
//

import Foundation
import UIKit
import MBProgressHUD

class Utils: NSObject {
    // MARK: - Show Normal Alert message
    
    class func showAlert(title: String = "", message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Show & Hide HUD
    
    class func showHUD(view: UIView, isShow: Bool = true) {
        guard isShow else { return }
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = ""
    }
    
    class func hideHUD(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    class func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let dateFormat = dateFormatter.date(from: date) {
            return dateFormat
        } else {
            return nil
        }
        
        return nil
    }
    
    class func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let numberOfDays = Calendar.current.dateComponents([.day], from: from, to: to)
        return numberOfDays.day!
    }
}

