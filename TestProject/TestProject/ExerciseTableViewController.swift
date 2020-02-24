//
//  ExerciseTableViewController.swift
//  TestProject
//
//  Created by vinsol on 24/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UIViewController {
    
    static let controllerId = "ExerciseTableViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource = ["1 brown fox jumps over the lazy dog","2 brown fox jumps over the lazy dog brown fox jumps over the lazy dog","3 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog","4 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog","5 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog","6 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog","7 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog","8 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog","9 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog","10 brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog brown fox jumps over the lazy dog"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    @IBAction func beginEditingCells(_ sender: UIButton) {
        tableView.isEditing = !tableView.isEditing
        tableView.reloadData()
        sender.setTitle((tableView.isEditing ? "DONE" : "EDIT"), for: UIControl.State.normal)
    }
    
    @IBAction func deleteSelectedCells() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for (i, indexPath) in selectedRows.sorted().enumerated() {
                dataSource.remove(at: indexPath.row - i)
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .right)
            tableView.endUpdates()
            
            tableView.reloadData()
        }
    }
    
}

extension ExerciseTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.cellId) as! ExerciseTableViewCell
        cell.setData(index: indexPath.row, data: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let data = dataSource.remove(at: sourceIndexPath.row)
        
        dataSource.insert(data, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    
}
