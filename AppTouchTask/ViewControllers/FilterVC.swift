//
//  FilterVC.swift
//  AppTouchTask
//
//  Created by Tejas Gowda KC on 14/12/22.
//

import UIKit
import MonthYearWheelPicker

class FilterVC: UIViewController {
    static let name = "FilterVC"
    static let storyBoard = "Main"
    
    /// The caller of this class does not need to know how we instantiate it.
    /// We simply return the instantiated class to the caller and they invoke it how they want
    /// If the as! fails, it will fail upon immediate testing
    class func instantiateFromStoryboard() -> FilterVC {
        let vc = UIStoryboard(name: FilterVC.storyBoard, bundle: nil).instantiateViewController(withIdentifier: FilterVC.name) as! FilterVC
        return vc
    }
    
    
    @IBOutlet var yearsFV: UIView!
    @IBOutlet var fromTF: UITextField!
    @IBOutlet var toTF: UITextField!
    @IBOutlet var filterTypeTF: UITextField!
    @IBOutlet var sortOrderTF: UITextField!
    @IBOutlet var cornerRadiusVs: [UIView]!
    
    var filterBy:((_ filter: Filter, _ sort: SortOrder) -> Void)?
    var filterYears:((_ fromYear: Int, _ fromMonth: Int, _ toYear: Int?, _ toMonth: Int?) -> Void)?
    var clearFilter:(() -> Void)?
    var filterPicker: UIPickerView!
    var sortPicker: UIPickerView!
    var filters = Filter.allCases
    var sortOption = SortOrder.allCases
    var fromDatePicker = MonthYearWheelPicker()
    var toDatePicker = MonthYearWheelPicker()
    
    var selectedFilter: Filter?
    var selectedSort: SortOrder = .asc
    var selectedFromYear = 0
    var selectedToYear = 0
    var selectedFromMonth = 0
    var selectedToMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterPicker()
        setupSortPicker()
        setupFomYearPicker()
        setupToYearPicker()
        cornerRadiusVs.forEach({ $0.setCornerRadius(radius: 15) })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedFilter = selectedFilter {
            filterTypeTF.text = selectedFilter.rawValue
            yearsFV.isHidden = selectedFilter != .years
            sortOrderTF.text = selectedSort.rawValue
            if selectedFilter == .years {
                fromTF.text = "\(selectedFromMonth)/\(selectedFromYear)"
                if selectedToYear > 0 {
                    toTF.text = "\(selectedToMonth)/\(selectedToYear)"
                }
            }
        } else {
            sortOrderTF.text = selectedSort.rawValue
        }
    }
    
    @IBAction func actionOnClosfilterse() {
        dismiss(animated: true)
    }
    
    @IBAction func actionOnFilter() {
        guard let selectedFilter = selectedFilter else {
            Utils.showAlert(message: "Select a filter type", viewController: self)
            return
        }
        if selectedFilter == .years && (fromTF.text ?? "").isEmpty {
            Utils.showAlert(message: "Select atleast the from year", viewController: self)
            return
        }
        dismiss(animated: true) {
            self.filterBy?(selectedFilter, self.selectedSort)
            if selectedFilter == .years {
                self.filterYears?(self.selectedFromYear, self.selectedFromMonth, self.selectedToYear, self.selectedToMonth)
            }
        }
    }
    
    @IBAction func actionOnClear() {
        dismiss(animated: true) {
            self.clearFilter?()
        }
    }
    
    func setupFilterPicker() {
        filterPicker = UIPickerView()
        filterPicker.dataSource = self
        filterPicker.delegate = self
        filterTypeTF.inputView = filterPicker
        filterTypeTF.inputAccessoryView = getToolBar()
    }
    
    func setupSortPicker() {
        sortPicker = UIPickerView()
        sortPicker.dataSource = self
        sortPicker.delegate = self
        sortOrderTF.inputView = sortPicker
        sortOrderTF.inputAccessoryView = getToolBar()
    }
    
    func setupFomYearPicker() {
        fromDatePicker = MonthYearWheelPicker()
        fromTF.inputView = fromDatePicker
        fromTF.inputAccessoryView = getToolBar()
        fromDatePicker.minimumDate = Date().addYears(n: -20)
        fromDatePicker.onDateSelected = { month, year in
            self.selectedFromYear = year
            self.selectedFromMonth = month
            self.fromTF.text = "\(month)/\(year)"
        }
    }
    
    func setupToYearPicker() {
        toDatePicker = MonthYearWheelPicker()
        toTF.inputView = toDatePicker
        toTF.inputAccessoryView = getToolBar()
        toDatePicker.minimumDate = Date().addYears(n: -20)
        toDatePicker.onDateSelected = { month, year in
            self.selectedToYear = year
            self.selectedToMonth = month
            self.toTF.text = "\(month)/\(year)"
        }
    }
    
    
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.white
        toolBar.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
}

extension FilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return  pickerView == filterPicker ? filters.count : sortOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == filterPicker ? filters[row].rawValue : sortOption[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == filterPicker {
            selectedFilter = filters[row]
            filterTypeTF.text = filters[row].rawValue
            yearsFV.isHidden = filters[row] != .years
        } else {
            selectedSort = sortOption[row]
            sortOrderTF.text = sortOption[row].rawValue
        }
        self.view.endEditing(true)
    }
}
