//
//  URToneCurveImageView.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 15..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class URToneCurveImageView: UIImageView, URToneCurveAppliable {
    var originalImage: UIImage!
}

extension URToneCurveAppliable where Self: UIImageView {
    func setFilteredImage(curvePoints: [CGPoint]) {
        if self.originalImage == nil {
            self.originalImage = self.image
        }

        let filter = URToneCurveFilter(self, with: curvePoints)
        filter.extractInputImage(self.originalImage)

        let filteredImage = filter.outputImage! //.applyFilter()

        self.image = UIImage(ciImage: filteredImage)
    }

    func removeFilter() {
        let filter = URToneCurveFilter(self)

        let rollbackImage = filter.rollbackFilter()
        self.image = UIImage(ciImage: rollbackImage)
    }
}

