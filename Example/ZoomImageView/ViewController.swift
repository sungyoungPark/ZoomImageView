//
//  ViewController.swift
//  ZoomImageView
//
//  Created by sungyoungPark on 07/07/2024.
//  Copyright (c) 2024 sungyoungPark. All rights reserved.
//

import UIKit
import SnapKit
import ZoomImageView

class ViewController: UIViewController {

    
    let zoomImageView = ZoomImageView(imageURL: "https://cdn.pixabay.com/photo/2020/05/31/16/53/bookmarks-5243253_1280.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(zoomImageView)
        zoomImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.lessThanOrEqualTo(self.view.frame.height)
            make.center.equalToSuperview()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

