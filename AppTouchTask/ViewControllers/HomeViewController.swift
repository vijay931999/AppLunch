//
//  HomeViewController.swift
//  AppTouchTask
//
//  Created by Vijay K on 12/12/22.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var tableV: UITableView!
    
    var company: Company?
    var launches: [Launches]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCompanyDetails()
        fetchLaunchesDetails()
    }
    
    /// This function is used for register tableV Cells in TableView.
    func registerTVC() {
        tableV.register(UINib(nibName: CompanyTVC.nibName, bundle: nil), forCellReuseIdentifier: CompanyTVC.reuseIdentifier)
        tableV.register(UINib(nibName: LaunchesTVC.nibName, bundle: nil), forCellReuseIdentifier: LaunchesTVC.reuseIdentifier)
    }
    
    func fetchCompanyDetails() {
        Utils.showHUD(view: view)
        RestAPI.fetchCompany { [weak self] companyData in
            guard let self = self else { return }
            Utils.hideHUD(view: self.view)
            self.company = companyData
            self.tableV.reloadData()
        }
    }
    
    func fetchLaunchesDetails() {
        Utils.showHUD(view: view)
        RestAPI.fetchLaunches { [weak self] launchesData in
            guard let self = self else { return }
            Utils.hideHUD(view: self.view)
            self.launches = launchesData
            self.tableV.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (launches?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: -5, width: headerView.frame.width , height: headerView.frame.height)
        label.text = section == 0 ? "   COMPANY" : "   LAUNCHES"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = .gray
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTVC.reuseIdentifier, for: indexPath) as! CompanyTVC
            cell.config(company: company)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesTVC.reuseIdentifier, for: indexPath) as! LaunchesTVC
            cell.config(launch: launches?[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        let alert = UIAlertController(title: nil, message: "Choose a option", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Articles", style: .default, handler: { _ in
            let urlString = self.launches?[indexPath.row].links?.article ?? ""
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { _ in
            let urlString = self.launches?[indexPath.row].links?.wikipedia ?? ""
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            let urlString = "htttps://www.youtube.com/watch?v=\(self.launches?[indexPath.row].links?.youtube_id ?? "")"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }
}
