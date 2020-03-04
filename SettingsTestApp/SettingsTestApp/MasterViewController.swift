//
//  ViewController.swift
//  SettingsTestApp
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    static let controllerId = "MasterViewController"
    
    private let data = DataHandler.shared
    private let dataSource: [[Enums.Detail]] = [[.airplaneMode,.wifi,.bluetooth,.mobileData,.carrier],[.notification,.donotDisturb],[.general,.wallpaper,.display]]
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: MasterSwitchTableViewCell.cellId) as! MasterSwitchTableViewCell
            cell.setUpCell(title: Enums.Detail.airplaneMode.title(), value: data.airplaneMode)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MasterNavigableTableViewCell.cellId) as! MasterNavigableTableViewCell
            let detail = dataSource[indexPath.section][indexPath.row]
            cell.setUpCell(title: detail, value: DataHandler.getValueString(detail: detail))
            return cell
        }
    }
    
    
}
