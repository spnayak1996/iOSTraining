//
//  ViewController.swift
//  GridProject
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static let controllerID = "ViewController"
    
    private var animationTime: Double = 2
    private var itemSize: CGFloat = 50
    private var spacing: CGFloat = 0
    
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    private let sourceArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    private var currentIndex: Int = 0 {
        didSet {
            currentIndex = currentIndex % 26
        }
    }
    private var dataSource = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func deleteItem(at indexPath: IndexPath, sender: UIButton?) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.transition(with: cell, duration: animationTime, options: .transitionFlipFromRight, animations: {
                self.dataSource.remove(at: indexPath.row)
                self.collectionView.deleteItems(at: [indexPath])
            }, completion: { (_) in
                sender?.isUserInteractionEnabled = true
            })
        } else {
            self.dataSource.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            sender?.isUserInteractionEnabled = true
        }
    }
    
    private func insertItem(at indexPath: IndexPath, sender: UIButton?) {
        collectionView.insertItems(at: [indexPath])
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0
        cell?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: animationTime, animations: {
            cell?.alpha = 1
            cell?.transform = CGAffineTransform.identity
        }, completion: { (_) in
            sender?.isUserInteractionEnabled = true
        })
    }
    
    private func insert3AtEnd(sender: UIButton?) {
        for i in 0...2 {
            let count = dataSource.count
            dataSource.append(sourceArray[currentIndex])
            insertItem(at: IndexPath(item: count, section: 0), sender: (i == 2) ? sender : nil)
            currentIndex += 1
        }
        
    }
    
    private func delete3AtEnd(sender: UIButton?) {
        for i in 0...2 {
            if dataSource.count > 0 {
                let lastIndex = dataSource.count - 1
                deleteItem(at: IndexPath(item: lastIndex, section: 0), sender: (i == 2) ? sender : nil)
            } else {
                sender?.isUserInteractionEnabled = true
            }
        }
    }
    
    private func delete3AtBeginning(sender: UIButton?) {
        for i in 0...2 {
            if dataSource.count > 0 {
                deleteItem(at: IndexPath(item: 0, section: 0), sender: (i == 2) ? sender : nil)
            }
        }
    }
    
    private func updateIndex2Cell(sender: UIButton?) {
        let changedValue = sourceArray[currentIndex]
        dataSource[2] = changedValue
        let cell = collectionView.cellForItem(at: IndexPath(item: 2, section: 0))
        UIView.transition(with: cell!, duration: animationTime, options: .transitionFlipFromTop, animations: {
            (cell as! MyCollectionViewCell).setUp(changedValue)
        }, completion: { (_) in
            sender?.isUserInteractionEnabled = true
        })
        currentIndex += 1
    }
    
    private func moveEToLast(sender: UIButton?) {
        if let index = dataSource.firstIndex(of: "e") {
            let oldIndexPath = IndexPath(item: index, section: 0)
            let newIndexPath = IndexPath(item: dataSource.count - 1, section: 0)
            dataSource.remove(at: index)
            dataSource.append("e")
            UIView.animate(withDuration: animationTime, animations: {
                self.collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            }) { (_) in
                sender?.isUserInteractionEnabled = true
            }
        }
    }
    
    private func performOneAfterOther(first: (UIButton?) -> (), second: @escaping (UIButton?) -> (), sender: UIButton) {
        first(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + animationTime + 0.1) {
            second(sender)
        }
    }
    
    private func openConfigureMenu() {
        let vc = self.storyboard?.instantiateViewController(identifier: ConfigurationViewController.controllerId) as! ConfigurationViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    
    @IBAction private func performAction(sender: UIButton) {
        sender.isUserInteractionEnabled = false
        switch sender.tag {
        case 1:
            insert3AtEnd(sender: sender)
        case 2:
            delete3AtEnd(sender: sender)
        case 3:
            updateIndex2Cell(sender: sender)
        case 4:
            moveEToLast(sender: sender)
        case 5:
            performOneAfterOther(first: delete3AtBeginning, second: insert3AtEnd, sender: sender)
        case 6:
            performOneAfterOther(first: insert3AtEnd, second: delete3AtBeginning, sender: sender)
        case 7:
            openConfigureMenu()
            sender.isUserInteractionEnabled = true
        default:
            break
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.cellId, for: indexPath) as! MyCollectionViewCell
        cell.setUp(dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteItem(at: indexPath, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
}

extension ViewController: ConfigurationViewControllerDelegate {
    func setConfiguration(time: Double?, size: Float?, spacing: Float?) {
        if let time = time, time < 5 {
            animationTime = time
        }
        if let spacing = spacing {
            self.spacing = CGFloat(spacing)
        }
        let width = Float(self.view.frame.size.width)
        let height = Float(self.view.frame.size.height)
        if let size = size, size <= width, size <= height, size >= 30 {
            self.itemSize = CGFloat(size)
        }
        collectionView.reloadData()
    }
    
    
}

