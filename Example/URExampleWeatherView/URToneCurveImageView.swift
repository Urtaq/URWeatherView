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
    func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]! = DefaultToneCurveInputs, pointsForGreen: [CGPoint]! = DefaultToneCurveInputs, pointsForBlue: [CGPoint]! = DefaultToneCurveInputs) {
        if self.originalImage == nil {
            self.originalImage = self.image
        }

        var filter = URToneCurveFilter(imageView: self, with: curvePoints)
        filter.extractInputImage(self.originalImage)

        let filteredImage = filter.outputImage!

        var arguments: [CIImage] = [CIImage]()
        if !(pointsForRed == DefaultToneCurveInputs
            && pointsForGreen == DefaultToneCurveInputs
            && pointsForBlue == DefaultToneCurveInputs) {
            var filteredImageForRed: CIImage!
            if let points = pointsForRed, points != DefaultToneCurveInputs {
                filter = URToneCurveFilter(curvePoints: points)
                filter.extractInputImage(self.originalImage)

                filteredImageForRed = filter.outputImage!
            } else {
                filteredImageForRed = filter.inputImage
            }
            arguments.append(filteredImageForRed)

            var filteredImageForGreen: CIImage!
            if let points = pointsForGreen, points != DefaultToneCurveInputs {
                filter = URToneCurveFilter(curvePoints: points)
                filter.extractInputImage(self.originalImage)

                filteredImageForGreen = filter.outputImage!
            } else {
                filteredImageForGreen = filter.inputImage
            }
            arguments.append(filteredImageForGreen)

            var filteredImageForBlue: CIImage!
            if let points = pointsForBlue, points != DefaultToneCurveInputs {
                filter = URToneCurveFilter(curvePoints: points)
                filter.extractInputImage(self.originalImage)

                filteredImageForBlue = filter.outputImage!
            } else {
                filteredImageForBlue = filter.inputImage
            }
            arguments.append(filteredImageForBlue)
        }

        if arguments.count == 3 {
            guard let resultImage: CIImage = URToneCurveFilter.colorKernel.apply(withExtent: filteredImage.extent, arguments: arguments) else {
                fatalError("Filtered Image merging is failed!!")
            }

            self.image = UIImage(ciImage: resultImage)
        } else {
            self.image = UIImage(ciImage: filteredImage)
        }
    }

    func removeFilter() {
        self.image = self.originalImage
    }
}

