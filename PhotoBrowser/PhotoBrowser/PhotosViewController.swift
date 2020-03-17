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
    private static let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private var loggedIn = false {
        didSet {
            fbLogin?.title = loginBtnTitle()
        }
    }
    private var fbLogin: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setLoggedIn()
        setCollectionViewItemSize(viewSize: nil)
        setUpFBLoginButton()
        getPhotos()
    }
    
    private func setLoggedIn() {
        if AccessToken.current != nil {
            loggedIn = true
        } else {
            loggedIn = false
        }
    }
    
    private func loginBtnTitle() -> String {
        return (loggedIn ? "Logout" : "Login")
    }
    
    private func setUpFBLoginButton() {
        fbLogin = UIBarButtonItem(title: loginBtnTitle(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(loginIntoFB(sender:)))
        self.navigationItem.rightBarButtonItem = fbLogin
    }
    
    @objc private func loginIntoFB(sender: UIBarButtonItem) {
        let loginManager = LoginManager()
        if loggedIn {
            loginManager.logOut()
            photos = [Photo]()
            collectionView.reloadData()
            loggedIn = false
        } else {
            loginManager.logIn(permissions: [.publicProfile, .email, .userPhotos], viewController: self) { (result) in
                self.getPhotos()
                self.loggedIn = true
            }
        }
    }
    
    private func setCollectionViewItemSize(viewSize: CGSize?) {
        let width = ((viewSize?.width ?? self.view.frame.size.width) - ((sectionInsets.left + sectionInsets.right) * (Self.itemsPerRow + 1)))/Self.itemsPerRow
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
                if let photo = photo {
                    self.photos.append(photo)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
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




