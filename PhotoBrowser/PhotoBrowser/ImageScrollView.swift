//
//  ImageScrollView.swift
//  PhotoBrowser
//
//  Created by vinsol on 27/02/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import UIKit

class ImageScrollView: UIView {
    
    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    private var extra: CGFloat!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image: UIImage, frame: CGRect, extra: CGFloat) {
        self.init(frame: frame)
        imageView = UIImageView(image: image)
        self.extra = extra
        setupScrollView()
        setUpNewZoomScale()
    }
    
    func reuseView(image: UIImage) {
        imageView.removeFromSuperview()
        imageView = UIImageView(image: image)
        setUpImageView()
        setUpNewZoomScale()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        scrollView.backgroundColor = UIColor(displayP3Red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        scrollView.delegate = self
        setUpImageView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
    }
    
    private func setUpImageView() {
        scrollView.contentSize = imageView.frame.size
        scrollView.addSubview(imageView)
    }
    
    private func setUpNewZoomScale() {
        setZoomScale(for: scrollView.frame.size)
        scrollView.zoomScale = scrollView.minimumZoomScale
//        recenterImage()
    }
    
    private func setZoomScale(for scrollViewSize: CGSize) {
        let imageSize = imageView.frame.size
        let widthScale = scrollViewSize.width/imageSize.width
        let heightScale = scrollViewSize.height/imageSize.height
        let minimumScale = min(heightScale,widthScale)
        
        scrollView.minimumZoomScale = minimumScale
        scrollView.maximumZoomScale = 3.0
    }
    
    private func recenterImage() {
        let scrollViewSize = scrollView.frame.size
        let imageViewSize = imageView.frame.size
        let horizontalSpace = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        let verticalSpace = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height - extra)/2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace + extra, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }

}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recenterImage()
    }
}
