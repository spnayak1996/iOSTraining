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
    private let sectionInsets = UIEdgeInsets(top: 0,
    left: 0,
    bottom: 0,
    right: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionViewItemSize()
        addFBLoginButton()
        getPhotos()
    }
    
    private func addFBLoginButton() {
        fbLogin = FBLoginButton(frame: CGRect(x: self.view.frame.width - 115, y: 7.5, width: 100, height: 30), permissions: [Permission.userPhotos])
        fbLogin.delegate = self
        self.navigationController?.navigationBar.addSubview(fbLogin)
    }
    
    private func setCollectionViewItemSize() {
        let width = (self.view.frame.size.width - ((sectionInsets.left + sectionInsets.right) * (itemsPerRow + 1)))/itemsPerRow
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    private func getPhotos() {
        if let userId = AccessToken.current?.userID {
            GraphRequest(graphPath: "/\(userId)/photos", parameters: ["fields":"images"]).start { (_, result, error) in
                if error != nil {
                    print(error ?? "unknown error")
                    return
                } else {
                    if let fbResult = result as? [String: AnyObject], let resultArray = fbResult["data"] as? [[String: AnyObject]] {
                        
                        for item in resultArray {
                            if let images = item["images"] as? [[String:AnyObject]], let url = images[0]["source"] as? String {
                                self.downloadPhoto(url: url, group: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func downloadPhoto(url: String, group: DispatchGroup?) {
        let _ = Photo(url: url) { (photo, error) in
            if let error = error {
                switch error {
                case .failed:
                    print("Failed")
                case .invalid_url:
                    print("Invalid URL")
                case .invalid_image:
                    print("Invalid Image")
                }
            } else {
                self.photos.append(photo!)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            group?.leave()
        }
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




