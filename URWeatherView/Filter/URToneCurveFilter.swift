//
//  URToneCurveFilter.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 12..
//  Copyright © 2017년 zigbang. All rights reserved.
//

open class URToneCurveFilter: URFilter {

    private var curveVectors: [CIVector]!

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required public init(frame: CGRect, cgImage: CGImage, inputValues: [Any]) {
        fatalError("init(frame:, cgImage:, inputValues:) has not been implemented")
    }

    required public init(frame: CGRect, imageView: UIImageView, inputValues: [Any]) {
        fatalError("init(frame:, imageView:, inputValues:) has not been implemented")
    }

    /// Must call the function "extractInputImage" on the instance, after calling this init method
    public init(curvePoints: [CGPoint] = [.zero, CGPoint(x: 1.0, y: 1.0)]) {
        super.init()

        self.curveVectors = [CIVector]()
        for point in curvePoints {
            let vector = CIVector(cgPoint: point)
            self.curveVectors.append(vector)
        }
    }

    convenience public init(ciImage: CIImage, with curvePoints: [CGPoint] = [.zero, CGPoint(x: 1.0, y: 1.0)]) {
        self.init(curvePoints: curvePoints)

        self.inputImage = ciImage
    }

    convenience public init(cgImage: CGImage, with curvePoints: [CGPoint] = [.zero, CGPoint(x: 1.0, y: 1.0)]) {
        self.init(curvePoints: curvePoints)

        self.extractInputImage(cgImage: cgImage)
    }

    convenience public init(imageView: UIImageView, with curvePoints: [CGPoint] = [.zero, CGPoint(x: 1.0, y: 1.0)]) {
        self.init(curvePoints: curvePoints)

        self.extractInputImage(imageView: imageView)
    }

    override func applyFilter() -> CIImage {
        var inputParameters: [String: Any] = [String: Any]()
        for (index, vector) in self.curveVectors.enumerated() {
            inputParameters["inputPoint\(index)"] = vector
        }
        inputParameters[kCIInputImageKey] = self.inputImage!

        return self.inputImage!.applyingFilter("CIToneCurve", withInputParameters: inputParameters)
    }

    func rollbackFilter() -> CIImage {
        self.setDefaults()

        return self.outputImage!
    }
}
