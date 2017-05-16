//
//  DetailViewController.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 21..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var originalImageView: URToneCurveImageView!
    @IBOutlet var graphView: URToneCurveGraphView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.graphView.drawLine(true)
    }

    @IBAction func tapApplyToneCurve(_ sender: Any) {
        print(#function)
        self.originalImageView.setFilteredImage(curvePoints: self.graphView.curveReletiveVectorPoints)
    }
}
