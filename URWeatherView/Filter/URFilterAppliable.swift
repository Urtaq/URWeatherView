//
//  URToneCurveAppliable.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 7..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import CoreImage

public protocol URFilterAppliable: class {
    var originalImages: [UIImage]! { get set }
    var effectTimer: Timer! { get set }

    func applyBackgroundEffect(imageAssets: [UIImage]?, duration: TimeInterval, userInfo: [String: Any]!)

    func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]!, pointsForGreen: [CGPoint]!, pointsForBlue: [CGPoint]!)
    func applyToneCurveFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]?)
    func removeToneCurveFilter()

    func applyFilterEffect(_ filterKernel: CIColorKernel, extent: CGRect, arguments: [Any], imageLayer: CALayer!)
    func applyFilterEffect(_ filterKernel: CIKernel, extent: CGRect, roiCallback: @escaping CIKernelROICallback, arguments: [Any], imageLayer: CALayer!)

    func applyDistortionFilter()
}

extension URFilterAppliable {
    public func applyBackgroundEffect(imageAssets: [UIImage]?, duration: TimeInterval, userInfo: [String: Any]!) {
    }

    public func setFilteredImage(curvePoints: [CGPoint], pointsForRed: [CGPoint]!, pointsForGreen: [CGPoint]!, pointsForBlue: [CGPoint]!) {
    }

    public func applyToneCurveFilter(filterValues: [String: [CGPoint]], filterValuesSub: [String: [CGPoint]]? = nil) {
    }

    public func applyFilterEffect(_ filterKernel: CIColorKernel, extent: CGRect, arguments: [Any], imageLayer: CALayer!) {
    }

    public func applyFilterEffect(_ filterKernel: CIKernel, extent: CGRect, roiCallback: @escaping CIKernelROICallback, arguments: [Any], imageLayer: CALayer!) {
    }

    public func applyDistortionFilter() {
    }
}

extension URFilterAppliable {
    func filterColorTone(red: CIImage, green: CIImage, blue: CIImage, originImage: CGImage, imageLayer: CALayer! = nil) {
        self.applyFilterEffect(URFilter.colorKernel, extent: red.extent, arguments: [red, green, blue, CIImage(cgImage: originImage)], imageLayer: imageLayer)
    }

    func filterBrighten(_ extent: CGRect, sampler: CISampler, ROICallback: @escaping CIKernelROICallback, bright: CGFloat, imageLayer: CALayer! = nil) {
        self.applyFilterEffect(URFilter.brightenKernel, extent: extent, roiCallback: ROICallback, arguments: [sampler, bright], imageLayer: imageLayer)
    }

    func filterMutiply(_ extent: CGRect, sampler: CISampler, ROICallback: @escaping CIKernelROICallback, color: CIColor, imageLayer: CALayer! = nil) {
        self.applyFilterEffect(URFilter.multiplyKernel, extent: extent, roiCallback: ROICallback, arguments: [sampler , color], imageLayer: imageLayer)
    }

    func filterHoleDistortion(_ extent: CGRect, sampler: CISampler, ROICallback: @escaping CIKernelROICallback, center: CIVector, radius: CIVector, imageLayer: CALayer! = nil) {
        self.applyFilterEffect(URFilter.holeDistortionKernel, extent: extent, roiCallback: ROICallback, arguments: [sampler, center, radius], imageLayer: imageLayer)
    }

    func filterSwirlDistortion(_ extent: CGRect, sampler: CISampler, ROICallback: @escaping CIKernelROICallback, center: CIVector, radius: CGFloat, angle: CGFloat, time: CGFloat, imageLayer: CALayer! = nil) {
        self.applyFilterEffect(URFilter.swirlKernel, extent: extent, roiCallback: ROICallback, arguments: [sampler, center, radius, angle, time], imageLayer: imageLayer)
    }

    func filterShockWaveDistortion(_ extent: CGRect, sampler: CISampler, ROICallback: @escaping CIKernelROICallback, center: CIVector, shockParams: CIVector, time: CGFloat, imageLayer: CALayer! = nil) {
        _ = URFilterAnimationManager(duration: TimeInterval(time), startTime: CACurrentMediaTime(), fireBlock: { (progress) in
            self.applyFilterEffect(URFilter.shockWaveKernel, extent: extent, roiCallback: ROICallback, arguments: [sampler, center, shockParams, progress], imageLayer: imageLayer)
        })
    }

    func filterWaveWarpDistortion(_ extent: CGRect, sampler: CISampler, ROICallback: @escaping CIKernelROICallback, center: CIVector, shockParams: CIVector, time: CGFloat, imageLayer: CALayer! = nil) {
        _ = URFilterAnimationManager(duration: TimeInterval(time), startTime: CACurrentMediaTime(), fireBlock: { (progress) in
            self.applyFilterEffect(URFilter.waveWarpKernel, extent: extent, roiCallback: ROICallback, arguments: [sampler, center, shockParams, progress], imageLayer: imageLayer)
        })
    }
}
