//
//  ViewController.swift
//  SettingsTestApp
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

protocol MasterSwitchCellDelegate: UIViewController {
    func setValue(_ val: Bool)
}

class MasterViewController: UIViewController {
    
    static let controllerId = "MasterViewController"
    private let detailSegue = "showDetail"
    
    private let data = DataHandler.shared
    private let dataSource: [[Enums.Detail]] = [[.airplaneMode,.wifi,.bluetooth,.mobileData,.carrier],[.notification,.donotDisturb],[.general,.wallpaper,.display]]
    private var filteredDataSource: [[Enums.Detail]] = [[.airplaneMode,.wifi,.bluetooth,.mobileData,.carrier],[.notification,.donotDisturb],[.general,.wallpaper,.display]]
    private var selectedDetail: Enums.Detail? = Enums.Detail.general
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            searchBar.searchTextField.backgroundColor = .white
        }
    }
    @IBOutlet private weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private var leftInset: CGFloat = 0
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Settings"
        addKeyboardObservers()
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillOpen(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillClose(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        leftInset = self.view.safeAreaInsets.left
        tableView.reloadData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillOpen(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillClose(notification: NSNotification) {
        if bottomConstraint.constant != 0 {
            bottomConstraint.constant = 0
        }
    }
    
    @objc private func keyBoardWillChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    private func checkIfPotrait() -> Bool {
        if self.traitCollection.horizontalSizeClass == .compact && (self.view.frame.height > self.view.frame.width) {
            return true
        } else {
            return false
        }
    }
    
    override func viewWillLayoutSubviews() {
        setPreviouslySelectedCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == detailSegue, let navigationVC = segue.destination as? UINavigationController, let dvc = navigationVC.viewControllers.first as? DetailViewController {
            if let cell = sender as? MasterNavigableTableViewCell {
                dvc.setUp(detail: cell.detail)
            } else if let detail = sender as? Enums.Detail {
                dvc.setUp(detail: detail)
            }
            dvc.delegate = self
            searchBar.resignFirstResponder()
        }
    }


}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataSource[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeaderCell", for: indexPath)
            return cell
        } else {
            let detail = filteredDataSource[indexPath.section][indexPath.row - 1]
            switch detail {
            case .airplaneMode:
                let cell = tableView.dequeueReusableCell(withIdentifier: MasterSwitchTableViewCell.cellId) as! MasterSwitchTableViewCell
                cell.setUpCell(title: Enums.Detail.airplaneMode.title(), value: data.airplaneMode, leftInset: self.leftInset)
                cell.delegate = self
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: MasterNavigableTableViewCell.cellId) as! MasterNavigableTableViewCell
                cell.setUpCell(title: detail, value: DataHandler.getValueString(detail: detail), last: indexPath.row == dataSource[indexPath.section].count, leftInset: self.leftInset)
                if selectedDetail == detail {
                    cell.isSelected = true
                    cell.setSelected(true, animated: false)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            setPreviouslySelectedCell()
        } else if filteredDataSource[indexPath.section][indexPath.row - 1] != .airplaneMode {
            let cell = tableView.cellForRow(at: indexPath)
            selectedDetail = filteredDataSource[indexPath.section][indexPath.row - 1]
            performSegue(withIdentifier: detailSegue, sender: cell)
        } else {
            setPreviouslySelectedCell()
        }
    }
    
}

extension MasterViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension MasterViewController: MasterSwitchCellDelegate {
    func setValue(_ val: Bool) {
        data.airplaneMode = val
        DataHandler.saveSettings(detail: .airplaneMode)
    }
}

extension MasterViewController: DetailViewControllerDelegate {
    func reload() {
        self.tableView.reloadData()
        setPreviouslySelectedCell()
    }
    
    private func setPreviouslySelectedCell() {
        tableView.reloadData()
        switch self.traitCollection.horizontalSizeClass {
        case .regular:
            if let indexPath = indexPathForDetail() {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            }
        default:
            break
        }
    }
    
    private func indexPathForDetail() -> IndexPath? {
        for (i, detailList) in filteredDataSource.enumerated() {
            for (j, detail) in detailList.enumerated() {
                if detail == selectedDetail {
                    return IndexPath(row: j + 1, section: i)
                }
            }
        }
        return nil
    }
    
    
}

extension MasterViewController: UISearchBarDelegate {
    private func filter(searchText: String) -> [[Enums.Detail]] {
        var array = [[Enums.Detail]]()
        
        for arr in dataSource {
            let filteredArray = arr.filter({ (detail) -> Bool in
                return detail.title().range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            if !filteredArray.isEmpty {
                array.append(filteredArray)
            }
        }
        return array
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredDataSource = searchText.isEmpty ? dataSource : filter(searchText: searchText)
        tableView.reloadData()
        setPreviouslySelectedCell()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = nil
        self.searchBar(searchBar, textDidChange: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
