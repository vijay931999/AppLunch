//
//  CompanyTVC.swift
//  AppTouchTask
//
//  Created by Vijay K on 13/12/22.
//

import UIKit

class CompanyTVC: UITableViewCell {
    static let nibName = "CompanyTVC"
    static let reuseIdentifier = nibName
    
    @IBOutlet var infoL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(company: Company?) {
        guard let company = company else {
            infoL.text = "Error in fetching company details"
            return
        }
        infoL.text = "\(company.name) was founded by \(company.founder) in \(company.founded). It has now \(company.employees) employees, \(company.launch_sites) launch sites, and is valued at USD \(company.valuation)"
    }
    
}
