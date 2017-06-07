//
//  URFilterAnimationManager.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 7..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import Foundation

public typealias URFilterAnimationFireBlock = (Double) -> Void
public class URFilterAnimationManager {
    var displayLink: CADisplayLink!
    var duration: TimeInterval = 1.0
    var transitionStartTime: CFTimeInterval = CACurrentMediaTime()

    @objc var timerFiredCallback: URFilterAnimationFireBlock

    init(duration: TimeInterval, startTime: CFTimeInterval, fireBlock: @escaping URFilterAnimationFireBlock) {
        self.duration = duration
        self.transitionStartTime = startTime
        self.timerFiredCallback = fireBlock

        self.displayLink = CADisplayLink(target: self, selector: #selector(timerFired(_:)))
        self.displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    @objc private func timerFired(_ displayLink : CADisplayLink) {
        let progress = min((CACurrentMediaTime() - self.transitionStartTime) / self.duration, 1.0)
        print("progress : \(progress), mediatime is \(CACurrentMediaTime()), self.transitionStartTime is \(self.transitionStartTime), duration : \(self.duration)")
        self.timerFiredCallback(progress)

        if progress == 1.0 {
            displayLink.invalidate()
        }
    }
}
