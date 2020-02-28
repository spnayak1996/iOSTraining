//
//  PhotosViewController.swift
//  PhotoBrowser
//
//  Created by vinsol on 27/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    static let controllerId = "PhotosViewController"
    
    @IBOutlet private var addPhotoView: UIView! {
        didSet {
            addPhotoView.layer.cornerRadius = 5
            addPhotoView.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
            addPhotoView.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var txtField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet private weak var btnAdd: UIButton!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    private var visualEffect: UIVisualEffect!
    private var photos = [Photo]()
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 0,
    left: 0,
    bottom: 0,
    right: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        visualEffect = blurView.effect
        blurView.effect = nil
        
        setCollectionViewItemSize()
    }
    
    private func setCollectionViewItemSize() {
        let width = (self.view.frame.size.width - ((sectionInsets.left + sectionInsets.right) * (itemsPerRow + 1)))/itemsPerRow
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    private func addPopUp() {
        self.view.addSubview(addPhotoView)
        addPhotoView.frame = CGRect(x: addPhotoView.frame.origin.x, y: addPhotoView.frame.origin.y, width: self.view.bounds.width - 60, height: addPhotoView.frame.height)
        addPhotoView.center = self.view.center
        
        addPhotoView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        addPhotoView.alpha = 0
        btnAdd.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5) {
            self.blurView.effect = self.visualEffect
            self.addPhotoView.alpha = 1
            self.addPhotoView.transform = CGAffineTransform.identity
        }
    }
    
    private func dismissPopUp() {
        UIView.animate(withDuration: 0.5, animations: {
            self.addPhotoView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.addPhotoView.alpha = 0
            self.blurView.effect = nil
        }) { (success) in
            if success {
                self.addPhotoView.transform = CGAffineTransform.identity
                self.addPhotoView.removeFromSuperview()
                self.btnAdd.isUserInteractionEnabled = true
            }
        }
    }
    
    private func downloadPhoto(url: String) {
        let _ = Photo(url: url) { (photo, error) in
            if let error = error {
                switch error {
                case .FAILED:
                    print("Failed")
                case .INVALID_URL:
                    print("Invalid URL")
                case .INVALID_IMAGE:
                    print("Invalid Image")
                }
            } else {
                self.photos.append(photo!)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    @IBAction private func addPhoto(_ sender: UIButton) {
        addPopUp()
    }
    
    @IBAction private func addAndDismissPopUp(_ sender: UIButton) {
        self.view.endEditing(true)
        if let text = txtField.text, !(text.trimmingCharacters(in: CharacterSet(charactersIn: " ")).isEmpty) {
            downloadPhoto(url: text)
        }
        dismissPopUp()
    }
    
    private func navigateToImageViewer(index: Int,_ list: [Photo]) {
        let vc = self.storyboard?.instantiateViewController(identifier: ImageViewerViewController.controllerId) as! ImageViewerViewController
        vc.setUp(index: index, list: list)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotosViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.cellId, for: indexPath) as! PhotoCell
        cell.imageView.image = photos[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToImageViewer(index: indexPath.row, photos)
    }
    
}

extension PhotosViewController : UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}




