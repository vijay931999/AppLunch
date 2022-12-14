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
    var filterLaunches: [Launches]?
    var launches: [Launches]?
    var filterBy: Filter?
    var sort: SortOrder = .asc
    var selectedFromYear = 0
    var selectedToYear = 0
    var selectedFromMonth = 0
    var selectedToMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCompanyDetails()
        fetchLaunchesDetails()
    }
    
    @IBAction func actionOnFilter() {
        let filterVc = FilterVC.instantiateFromStoryboard()
        filterVc.filterBy = { filterType, sortOrder in
            self.filterBy = filterType
            self.sort = sortOrder
            self.filter()
        }
        filterVc.filterYears = { fromYear, fromMonth, toYear, toMonth in
            self.selectedFromYear = fromYear
            self.selectedFromMonth = fromMonth
            self.selectedToYear = toYear ?? 0
            self.selectedToMonth = toMonth ?? 0
            self.filter()
        }
        filterVc.clearFilter = {
            self.filterBy = nil
            self.filter()
        }
        filterVc.selectedFilter = filterBy
        filterVc.selectedSort = sort
        filterVc.selectedFromYear = selectedFromYear
        filterVc.selectedFromMonth = selectedFromMonth
        filterVc.selectedToYear = selectedToYear
        filterVc.selectedToMonth = selectedToMonth
        
        filterVc.modalPresentationStyle = .overCurrentContext
        present(filterVc, animated: true)
    }
    
    func filter()  {
        switch filterBy {
        case .years:
            if selectedToYear > 0 {
                filterLaunches = launches?.filter({ $0.date_local.toDate.isBetween("\(selectedFromMonth)/\(selectedFromYear)".toDateMonthYear.startOfMonth(), and: "\(selectedToMonth)/\(selectedToYear)".toDateMonthYear.endOfMonth())})
            } else {
                filterLaunches = launches?.filter({ $0.date_local.toDate.isBetween("\(selectedFromMonth)/\(selectedFromYear)".toDateMonthYear.startOfYear, and: "\(selectedFromMonth)/\(selectedFromYear)".toDateMonthYear.endOfYear)})
            }
            filterLaunches = filterLaunches?.sorted(by: { $0.date_local.toDate.compare($1.date_local.toDate) == (sort == .asc ? .orderedAscending : .orderedDescending) })
        case .successful:
            filterLaunches = launches?.filter({ $0.success })
            filterLaunches = filterLaunches?.sorted(by: { $0.date_local.toDate.compare($1.date_local.toDate) == (sort == .asc ? .orderedAscending : .orderedDescending) })
        case .fialures:
            filterLaunches = launches?.filter({ !$0.success })
            filterLaunches = filterLaunches?.sorted(by: { $0.date_local.toDate.compare($1.date_local.toDate) == (sort == .asc ? .orderedAscending : .orderedDescending) })
        default:
            filterLaunches = launches
        }
        tableV.reloadData()
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
            self.filterLaunches = launchesData
            self.tableV.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (filterLaunches?.count ?? 0)
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
            cell.config(launch: filterLaunches?[indexPath.row])
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
            let urlString = self.filterLaunches?[indexPath.row].links?.article ?? ""
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Wikipedia", style: .default, handler: { _ in
            let urlString = self.filterLaunches?[indexPath.row].links?.wikipedia ?? ""
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            let urlString = "htttps://www.youtube.com/watch?v=\(self.filterLaunches?[indexPath.row].links?.youtube_id ?? "")"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }
}
