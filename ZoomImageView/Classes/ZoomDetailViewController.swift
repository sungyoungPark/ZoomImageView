//
//  ZoomDetailViewController.swift
//  ZoomImageView
//
//  Created by 박성영 on 7/7/24.
//

import UIKit

class ZoomDetailViewController: UIViewController {
    
    lazy var mainScrollView : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.isPagingEnabled = true
        scrollview.delegate = self
        scrollview.contentInsetAdjustmentBehavior = .never
        scrollview.bounces = false
        
        scrollview.backgroundColor = .clear
        
        return scrollview
    }()
    
    lazy var innerScrollView : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.maximumZoomScale = 4.0
        scrollview.minimumZoomScale = 1.0
        
        scrollview.bouncesZoom = false
        scrollview.bounces = false
        scrollview.decelerationRate = UIScrollViewDecelerationRateFast
        scrollview.delegate = self
        scrollview.contentInsetAdjustmentBehavior = .never
        
        scrollview.backgroundColor = .black
        
        return scrollview
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(mainScrollView)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDoubleAction))
        doubleTapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGesture)
        
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
        }
        
        mainScrollView.addSubview(innerScrollView)
        
        innerScrollView.snp.makeConstraints { make in
            make.top.width.height.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        innerScrollView.addSubview(imageView)
        imageView.image = imageView.image?.resize(newWidth: self.view.frame.width)
        imageView.frame.size = imageView.image?.size ?? .zero
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.backgroundColor = .clear
        closeBtn.setTitle("X", for: .normal)
        closeBtn.titleLabel?.font = .boldSystemFont(ofSize: 50)
        closeBtn.tintColor = .white
        
        closeBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        self.view.addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            maker.trailing.equalTo(-12)
            maker.width.height.equalTo(50)
        }
    }
    
    
    
}

extension ZoomDetailViewController : UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    
    @objc private func tapDoubleAction(recognizer: UITapGestureRecognizer) {
    
        if innerScrollView.zoomScale > innerScrollView.minimumZoomScale {
            innerScrollView.setZoomScale(innerScrollView.minimumZoomScale, animated: true)
        }
        else {
            let zoomRect = zoomRectForScale(scale: innerScrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view))
            innerScrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    @objc private func backButtonAction() {
       
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect()
        let bounds = innerScrollView.bounds
        
        zoomRect.size.width = bounds.width / scale
        zoomRect.size.height = bounds.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
}
