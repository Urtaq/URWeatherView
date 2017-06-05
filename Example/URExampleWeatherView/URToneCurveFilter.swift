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
    var originalImages: [UIImage]! { get set }
    var effectTimer: Timer! { get set }

    func applyBackgroundEffect(imageAssets: [UIImage], duration: TimeInterval)

    func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]!, pointsForGreen: [CGPoint]!, pointsForBlue: [CGPoint]!)
    func applyToneCurveFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]?)
    func removeToneCurveFilter()

    func replaceLayer(_ targetLayer: CALayer, with cgImage: CGImage)
}

extension URToneCurveAppliable {
    func applyBackgroundEffect(imageAssets: [UIImage], duration: TimeInterval) {
    }

    func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]!, pointsForGreen: [CGPoint]!, pointsForBlue: [CGPoint]!) {
    }

    func applyToneCurveFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]? = nil) {
    }

    func replaceLayer(_ targetLayer: CALayer, with cgImage: CGImage) {
    }
}

class URToneCurveFilter: CIFilter {
    var inputImage: CIImage?
    private var curveVectors: [CIVector]!

    public static let colorKernelForRGB: CIColorKernel = CIColorKernel(string:
        "kernel vec4 combineRGBChannel(__sample rgb) {" +
        "   return vec4(rgb.rgb, 1.0);" +
        "}")!

    public static let colorKernel: CIColorKernel = CIColorKernel(string:
        "kernel vec4 combineRGBChannel(__sample red, __sample green, __sample blue, __sample rgb) {" +
            "   vec4 result = vec4(red.r, green.g, blue.b, rgb.a);" +
            "   bool isTransparency = true;" +
            "   if (red.r == 0.0 && red.g == 0.0 && red.b == 0.0 && red.a == 0.0) {" +
            "       result.r = 0.0;" +
            "   } else {" +
            "       isTransparency = false;" +
            "   }" +
            "   if (green.r == 0.0 && green.g == 0.0 && green.b == 0.0 && green.a == 0.0) {" +
            "       result.g = 0.0;" +
            "   } else {" +
            "       isTransparency = false;" +
            "   }" +
            "   if (blue.r == 0.0 && blue.g == 0.0 && blue.b == 0.0 && blue.a == 0.0) {" +
            "       result.b = 0.0;" +
            "   } else {" +
            "       isTransparency = false;" +
            "   }" +
            "   if (isTransparency) {" +
            "       result.a = 0.0;" +
            "   }" +
            "   return result;" +
        "}")!

    public static let kernel: CIKernel = CIKernel(string:
        "kernel vec4 brightenEffect (sampler src, float k)\n" +
        "{\n" +
        "    vec4 currentSource = sample (src, samplerCoord (src));         // 1\n" +
        "    currentSource.rgb = currentSource.rgb + k * currentSource.a;   // 2\n" +
        "    return currentSource;                                          // 3\n" +
        "}")!

    public static let holeDistortionKernel: CIKernel = CIKernel(string:
        "kernel vec4 holeDistortion (sampler src, vec2 center, vec2 params)   // 1\n" +
        "{\n" +
        "    vec2 t1;\n" +
        "    float distance0, distance1;\n" +
        "\n" +
        "    t1 = destCoord () - center;                                        // 2\n" +
        "    distance0 = dot (t1, t1);                                          // 3\n" +
        "    t1 = t1 * inversesqrt (distance0);                                 // 4\n" +
        "    distance0 = distance0 * inversesqrt (distance0) * params.x;        // 5\n" +
        "    distance1 = distance0 - (1.0 / distance0);                         // 6\n" +
        "    distance0 = (distance0 < 1.0 ? 0.0 : distance1) * params.y;        // 7\n" +
        "    t1 = t1 * distance0 + center;                                      // 8\n" +
        "\n" +
        "    return sample (src, samplerTransform (src, t1));                   // 9\n" +
        "}"
        )!

    public static let multiplyKernel: CIKernel = CIKernel(string:
        "kernel vec4 multiplyEffect (sampler src, __color mul)\n" +
        "{\n" +
        "    return sample (src, samplerCoord (src)) * mul;\n" +
        "}"
    )!

    public static let swirlKernel: CIKernel = CIKernel(string:
        "kernel vec4 postFX(sampler tex, vec2 uv, float time)\n" +
        "{\n" +
            "float rt_w = samplerSize(tex).x;\n" +
            "float rt_h = samplerSize(tex).y;\n" +
            "vec2 center = vec2(400.0, 300.0);\n" +
            "vec2 texSize = vec2(rt_w, rt_h);\n" +
            "vec2 tc = uv * texSize;\n" +
            "tc -= center;\n" +
            "float dist = length(tc);\n" +
            "if (dist < 200.0)\n" +
            "{\n" +
                "float percent = (200.0 - dist) / 200.0;\n" +
                "float theta = percent * percent * 0.8 * 8.0;\n" +
                "float s = sin(theta);\n" +
                "float c = cos(theta);\n" +
                "tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));\n" +
            "}\n" +
            "tc += center;\n" +
//            "vec3 color = texture(tex, tc / texSize).rgb;\n" +
//            "return vec4(color, 1.0);" +
//            "return sample (tex, samplerCoord (tex));" +
            "    return sample (tex, samplerTransform (tex, tc / texSize));                   // 9\n" +
        "}"
    )!

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
//        if let filter = CIFilter(name: "CIToneCurve", withInputParameters: inputParameters) {
//            print(filter)
//        }

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
