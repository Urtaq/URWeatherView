//
//  URToneCurveFilter.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 12..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import CoreImage

public protocol URToneCurveAppliable: class {
    var originalImage: UIImage! { get set }

    func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]!, pointsForGreen: [CGPoint]!, pointsForBlue: [CGPoint]!)
    func removeFilter()
}

class URToneCurveFilter: CIFilter {
    var inputImage: CIImage?
    private var curveVectors: [CIVector]!

    public static var colorKernelForRGB: CIColorKernel = CIColorKernel(string:
        "kernel vec4 combineRGBChannel(__sample rgb)" +
        "{" +
        "   return vec4(rgb.rgb, 1.0);" +
        "}")!

    public static var colorKernel: CIColorKernel = CIColorKernel(string:
        "kernel vec4 combineRGBChannel(__sample red, __sample green, __sample blue)" +
            "{" +
            "   return vec4(red.r, green.g, blue.b, 1.0);" +
        "}")!

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Must call the function "extractInputImage" on the instance, after calling this init method
    convenience init(curvePoints: [CGPoint] = [.zero, CGPoint(x: 1.0, y: 1.0)]) {
        self.init()

        self.curveVectors = [CIVector]()
        for point in curvePoints {
            let vector = CIVector(cgPoint: point)
            self.curveVectors.append(vector)
        }
    }

    convenience init(cgImage: CGImage, with curvePoints: [CGPoint] = [.zero, CGPoint(x: 1.0, y: 1.0)]) {
        self.init()

        self.extractInputImage(cgImage: cgImage)

        self.curveVectors = [CIVector]()
        for point in curvePoints {
            let vector = CIVector(cgPoint: point)
            self.curveVectors.append(vector)
        }
    }

    convenience init(imageView: UIImageView, with curvePoints: [CGPoint] = [.zero, CGPoint(x: 1.0, y: 1.0)]) {
        self.init()

        self.extractInputImage(imageView: imageView)

        self.curveVectors = [CIVector]()
        for point in curvePoints {
            let vector = CIVector(cgPoint: point)
            self.curveVectors.append(vector)
        }
    }

    override var outputImage: CIImage? {
        return self.applyFilter()
    }

    private func applyFilter() -> CIImage {
        var inputParameters: [String: Any] = [String: Any]()
        for (index, vector) in self.curveVectors.enumerated() {
            inputParameters["inputPoint\(index)"] = vector
        }
        inputParameters[kCIInputImageKey] = self.inputImage!

        // for checking the filter values
        if let filter = CIFilter(name: "CIToneCurve", withInputParameters: inputParameters) {
            print(filter)
        }

        return self.inputImage!.applyingFilter("CIToneCurve", withInputParameters: inputParameters)
    }

    func rollbackFilter() -> CIImage {
        self.setDefaults()

        return self.outputImage!
    }

    func extractInputImage(cgImage: CGImage) {
        let ciImage = CIImage(cgImage: cgImage)
        self.inputImage = ciImage
    }

    func extractInputImage(_ image: UIImage) {
        if let ciImage = CIImage(image: image) {
            self.inputImage = ciImage

            return
        }

        if let ciImage = image.ciImage {
            self.inputImage = ciImage

            return
        }

        fatalError("Cannot get Core Image!!")
    }

    func extractInputImage(imageView: UIImageView) {
        guard let rawImage = imageView.image else {
            fatalError("The UIImageView must have image!!")
        }
        self.extractInputImage(rawImage)
    }
}
