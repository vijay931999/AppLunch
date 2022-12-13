//
//  LaunchesTVC.swift
//  AppTouchTask
//
//  Created by Vijay K on 13/12/22.
//

import UIKit
import SDWebImage

class LaunchesTVC: UITableViewCell {
    static let nibName = "LaunchesTVC"
    static let reuseIdentifier = nibName
    
    @IBOutlet var missionNameL: UILabel!
    @IBOutlet var dateL: UILabel!
    @IBOutlet var rocketL: UILabel!
    @IBOutlet var daysTL: UILabel!
    @IBOutlet var daysCountL: UILabel!
    @IBOutlet var imageV: UIImageView!
    @IBOutlet var successImageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    func config(launch: Launches?) {
        guard let launch = launch else {
            reset()
            return
        }
        imageV.sd_setImage(with: URL(string: launch.links?.patch?.large ?? ""), placeholderImage: UIImage(systemName: "photo"))
        missionNameL.text = launch.name
        dateL.text = Utils.getDate(date: launch.date_local)?.toString(dateFormat: "dd/MM/yyyy 'at' HH:mm")
        rocketL.text = launch.rocket
        successImageV.image = launch.success ? UIImage(named: "tick") : UIImage(systemName: "xmark")
        daysTL.text = "Days \(Utils.numberOfDaysBetween(Date(), and: Utils.getDate(date: launch.date_local) ?? Date()) < 0 ? "since" : "from") now:"
        daysCountL.text = "\(Utils.numberOfDaysBetween(Date(), and: Utils.getDate(date: launch.date_local) ?? Date()))"
    }
    
    func reset() {
        imageV.image =  UIImage(systemName: "photo")
        successImageV.image = UIImage(named: "tick")
        missionNameL.text = "Unknown"
        dateL.text = "Unknown"
        rocketL.text = "Unknown"
        daysTL.text = "Unknown"
        daysCountL.text = "Unknown"
    }
}
