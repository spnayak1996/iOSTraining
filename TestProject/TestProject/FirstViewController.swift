//
//  FirstViewController.swift
//  TestProject
//
//  Created by vinsol on 18/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSecondVC()
    }
    
    private func setUpSecondVC() {
        let vc = self.storyboard?.instantiateViewController(identifier: TestTableViewController.controllerId) as! TestTableViewController
        var vcArray = self.navigationController!.viewControllers
        vcArray.insert(vc, at: 1)
        self.navigationController?.viewControllers = vcArray
    }
}

class FirstViewController: UIViewController {
    
    private enum Change {
        case DELETE, INSERT
    }
    
    static let controllerId = "FirstViewController"
    
    @objc dynamic fileprivate var dataSource = [1,2,3,4,5,6,7,8,9]
    private var count = 10
    var observation: NSKeyValueObservation?
    
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func btnClicked() {
//        let vc = self.storyboard?.instantiateViewController(identifier: TestTableViewController.controllerId) as! TestTableViewController
        let vc = self.storyboard?.instantiateViewController(identifier: "ThirdViewController") as! ThirdViewController
//        vc?.modalPresentationStyle = UIModalPresentationStyle.popover
//        self.showDetailViewController(vc!, sender: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        buttonConstraint.constant = view.bounds.height
        
        observation = observe(\.dataSource, options: [.new, .old], changeHandler: { (controller, change) in
            if let oldValue = change.oldValue, let newValue = change.newValue {
                print("oldValue: ",oldValue,"newValue: ",newValue)
                switch self.evaluateChange(old: oldValue, new: newValue) {
                case (let c, let n):
                    if c == .INSERT {
                        self.insertNewCell(index: n)
                    } else {
                        self.deleteCell(index: n)
                    }
                }
            }
        })
    }
    
    deinit {
        observation = nil
    }
    
    private func evaluateChange(old: [Int], new: [Int]) -> (Change, Int) {
        var change = Change.INSERT
        var index = old.count
        
        if old.count > new.count {
            change = .DELETE
            index = Utils.findFirstDeletedIndex(old: old, new: new)
        }
        
        return (change, index)
    }
    
    private func insertNewCell(index: Int) {
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .right)
        tableView.endUpdates()
    }
    
    private func deleteCell(index: Int) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
        tableView.endUpdates()
    }
    
    @IBAction func addCells() {
        dataSource.append(count)
        count += 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.buttonConstraint.constant = 40
            self.view.layoutIfNeeded()
            print("animated")
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FirstTableViewCell.cellId) as! FirstTableViewCell
        cell.delegate = self
        cell.setUp(data: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

extension FirstViewController: FirstTableViewCellDelegate {
    func deleteCell(cell: FirstTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            dataSource.remove(at: indexPath.row)
        }
    }
    
    
}

struct Utils {
    static func findFirstDeletedIndex<Element: Equatable>(old: [Element], new: [Element]) -> Int {
        for (i,n) in new.enumerated() {
            if n != old[i] {
                return i
            }
        }
        return old.count - 1
    }
}
