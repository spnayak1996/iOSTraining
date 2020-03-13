//
//  PhotosViewController.swift
//  PhotoBrowser
//
//  Created by vinsol on 27/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class PhotosViewController: UIViewController {
    
    static let controllerId = "PhotosViewController"
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    private var photos = [Photo]()
    private var fbLogin: FBLoginButton!
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionViewItemSize(viewSize: nil)
        addFBLoginButton()
        getPhotos()
    }
    
    private func addFBLoginButton() {
        if fbLogin != nil {
            fbLogin.removeFromSuperview()
        }
        fbLogin = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30), permissions: [Permission.publicProfile, Permission.email,Permission.userPhotos])
        fbLogin.delegate = self
        resetButtonFrame()
        self.navigationController?.navigationBar.addSubview(fbLogin)
    }
    
    private func resetButtonFrame() {
        if let frame = self.navigationController?.navigationBar.frame {
            fbLogin.frame = CGRect(x: frame.width - 110, y: (frame.height - 30)/2, width: 100, height: 30)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if fbLogin != nil {
            let frame = fbLogin.frame
            fbLogin.frame = CGRect(x: size.width - 110, y: frame.origin.y, width: 100, height: 30)
            setCollectionViewItemSize(viewSize: size)
        }
    }
    
    private func setCollectionViewItemSize(viewSize: CGSize?) {
        let width = ((viewSize?.width ?? self.view.frame.size.width) - ((sectionInsets.left + sectionInsets.right) * (itemsPerRow + 1)))/itemsPerRow
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: width, height: width)
        }
    }
    
    private func getPhotos() {
        downloadAllPhotos { (photo, error) in
            if let error = error {
                switch error {
                case .failed:
                    print("Failed")
                case .invalidUrl:
                    print("Invalid URL")
                case .invalidImage:
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
    
    private func downloadAllPhotos(completion: @escaping PhotoDownloadCompletionBlock) {
        Photo.downloadAll(completion: completion)
    }
    
    private func navigateToImageViewer(index: Int,_ list: [Photo]) {
        let vc = self.storyboard?.instantiateViewController(identifier: ImageViewerViewController.controllerId) as! ImageViewerViewController
        vc.setUp(index: index, list: list)
        vc.fbLogin = self.fbLogin
        fbLogin.delegate = vc
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

extension PhotosViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("user logged out")
        photos = [Photo]()
        collectionView.reloadData()
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        getPhotos()
    }
}




