//
//  ImageViewerViewController.swift
//  PhotoBrowser
//
//  Created by vinsol on 27/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit
import FacebookLogin

class ImageViewerViewController: UIViewController {
    
    static let controllerId = "ImageViewerViewController"
    
    private var views = [ImageScrollView]()
    private var currentViewIndex: Int!
    private var index: Int!
    private var photos: [Photo]!
    
    private var observation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    deinit {
        observation = nil
    }
    
    private func setUpViews() {
        let viewHeight: CGFloat = self.view.frame.size.height
        let viewWidth: CGFloat = self.view.frame.size.width
        let scrollView = createScrollView(viewWidth: viewWidth, viewHeight: viewHeight)
        self.view.addSubview(scrollView)
        
        setUpObserver(view: scrollView)
    }
    
    private func createScrollView(viewWidth: CGFloat, viewHeight: CGFloat) -> UIScrollView {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        let extra = self.navigationController?.navigationBar.bounds.height ?? 0
        scrollView.isPagingEnabled = true
        var xPostion: CGFloat = 0
        for i in 0...2 {
            let view = ImageScrollView(image: photos[rectifyIndex(index: (index - 1 + i), count: photos.count)].image!, frame: CGRect(x: xPostion, y: 0, width: viewWidth, height: viewHeight), extra: extra)
            xPostion += viewWidth
            views.append(view)
            scrollView.addSubview(view)
        }
        scrollView.contentSize = CGSize(width: xPostion, height: viewHeight)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentOffset = CGPoint(x: viewWidth, y: 0)
        return scrollView
    }
    
    private func setUpObserver(view: UIScrollView) {
        observation = view.observe(\UIScrollView.contentOffset, options: [.new], changeHandler: { (myScrollView, change) in
            if abs(change.newValue!.x - self.view.bounds.width) == self.view.bounds.width {
                self.index = change.newValue!.x > 0 ? self.rectifyIndex(index: self.index + 1, count: self.photos.count) : self.rectifyIndex(index: self.index - 1, count: self.photos.count)
                self.resetImages()
                view.contentOffset = CGPoint(x: self.view.bounds.width, y: 0)
            }
        })
    }
    
    private func resetImages() {
        for (i,view) in views.enumerated() {
            let image = photos[rectifyIndex(index: (index - 1 + i), count: photos.count)].image!
            view.reuseView(image: image)
        }
    }
    
    func setUp(index: Int, list: [Photo]) {
        self.index = index
        self.photos = list
    }
    
    private func rectifyIndex(index: Int, count: Int) -> Int {
        return (index + count) % count
    }

}
