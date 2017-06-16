//
//  DetailViewController.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 4. 21..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import URWeatherView

class DetailViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var originalImageView: URFilterImageView!
//    @IBOutlet var graphView: URToneCurveGraphView!
    @IBOutlet var toneCurveView: URToneCurveView!

    @IBOutlet var txtResultCurve: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.graphView.drawLine(true, needToInit: true)
        self.toneCurveView.initView()
        self.toneCurveView.applyBlock = { (resultString) in
            self.originalImageView.setFilteredImage(
                curvePoints: self.toneCurveView.vectorPoints
                , pointsForRed: self.toneCurveView.vectorPointsForRed
                , pointsForGreen: self.toneCurveView.vectorPointsForGreen
                , pointsForBlue: self.toneCurveView.vectorPointsForBlue)

            self.txtResultCurve.text = resultString
        }
        self.toneCurveView.setImageBlock = { (image) in
            self.originalImageView.originalImages = nil
            self.originalImageView.image = image
        }
        self.toneCurveView.parentViewController = self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView {
            self.txtResultCurve.resignFirstResponder()
        }
    }
}
