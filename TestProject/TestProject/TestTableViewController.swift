//
//  TestTableViewController.swift
//  TestProject
//
//  Created by vinsol on 19/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {
    
    static let controllerId = "TestTableViewController"
    
    private var firstTimeShowing: Bool = true
    
    private var dataSource: [Double] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(UINib(nibName: TestTableViewCell.cellId, bundle: nil), forCellReuseIdentifier: TestTableViewCell.cellId)
        
        perform(#selector(addWithDelay), with: nil, afterDelay: 3)
    }
    
    private func insertInDataSource(_ val: Double) -> IndexPath {
        var row = dataSource.count
        for (i, n) in dataSource.enumerated() {
            if val <= n {
                row = i
                break
            }
        }
        dataSource.insert(val, at: row)
        return IndexPath(row: row, section: 0)
    }
    
    @objc private func addWithDelay() {
        let indexPath1 = insertInDataSource(8.5)
        let indexPath2 = insertInDataSource(11.2)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath1, indexPath2], with: .none)
        self.tableView.endUpdates()
    }
    
    deinit {
        print("deinitialized \(Self.controllerId)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstTimeShowing = true
        
//        animateTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.cellId, for: indexPath) as! TestTableViewCell
        cell.lblText.text = "\(dataSource[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: DetailViewController.controllerId) as! DetailViewController
        vc.setValue("\(dataSource[indexPath.row])")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let displacement = tableView.bounds.size.width
        cell.transform = CGAffineTransform(translationX: displacement , y: 0)
        UIView.animate(withDuration: 1.5, delay: (self.firstTimeShowing ? Double(indexPath.row) * 0.04 : 0.04), usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        }, completion: { (success) in
            if success {
                self.firstTimeShowing = false
            }
        })
    }
    
    
    
//    func animateTable() {
//        tableView.reloadData()
//        let cells = tableView.visibleCells
//
//        let displacement = tableView.bounds.size.width
//
//        for cell in cells {
//            cell.transform = CGAffineTransform(translationX: displacement , y: 0)
//        }
//
//        for (i, cell) in cells.enumerated() {
//            UIView.animate(withDuration: 3, delay: Double(i) * 0.05, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//        }
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
