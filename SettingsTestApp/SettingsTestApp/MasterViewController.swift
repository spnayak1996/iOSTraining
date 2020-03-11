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
    private var filteredDataSource: [[Enums.Detail]]!
    private var selectedDetail: Enums.Detail? = Enums.Detail.general
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredDataSource = dataSource
        tableView.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        setPreviouslySelectedCell()
//    }
    
    override func viewWillLayoutSubviews() {
        setPreviouslySelectedCell()
    }
  
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        tableView.reloadData()
//        setPreviouslySelectedCell()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == detailSegue, let cell = sender as? MasterNavigableTableViewCell, let navigationVC = segue.destination as? UINavigationController, let dvc = navigationVC.viewControllers.first as? DetailViewController {
            dvc.setUp(detail: cell.detail)
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
        return filteredDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = filteredDataSource[indexPath.section][indexPath.row]
        switch detail {
        case .airplaneMode:
            let cell = tableView.dequeueReusableCell(withIdentifier: MasterSwitchTableViewCell.cellId) as! MasterSwitchTableViewCell
            cell.setUpCell(title: Enums.Detail.airplaneMode.title(), value: data.airplaneMode)
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MasterNavigableTableViewCell.cellId) as! MasterNavigableTableViewCell
            cell.setUpCell(title: detail, value: DataHandler.getValueString(detail: detail))
            if selectedDetail == detail {
                cell.isSelected = true
                cell.setSelected(true, animated: false)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredDataSource[indexPath.section][indexPath.row] != .airplaneMode {
            let cell = tableView.cellForRow(at: indexPath)
            selectedDetail = filteredDataSource[indexPath.section][indexPath.row]
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
                    return IndexPath(row: j, section: i)
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
