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
//    @IBOutlet var graphView: URToneCurveGraphView!
    @IBOutlet var toneCurveView: URToneCurveView!

    @IBOutlet var lbResultCurve: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.graphView.drawLine(true, needToInit: true)
        self.toneCurveView.initView()
        self.toneCurveView.applyBlock = {
            self.originalImageView.setFilteredImage(
                curvePoints: self.toneCurveView.vectorPoints
                , pointsForRed: self.toneCurveView.vectorPointsForRed
                , pointsForGreen: self.toneCurveView.vectorPointsForGreen
                , pointsForBlue: self.toneCurveView.vectorPointsForBlue)

            
        }
    }
}
