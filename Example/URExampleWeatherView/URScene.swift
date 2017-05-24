//
//  URScene.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 23..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import SpriteKit

public protocol URScene: class {
    var emitter: SKEmitterNode! { get set }

    var isGraphicsDebugOptionEnabled: Bool { get set }

    var extraEffectBlock: ((UIImage?) -> Void)? { get set }

    func startScene() -> SKScene?
}

extension URScene where Self: SKScene {
    func enableDebugOptions(needToShow: Bool) {
        self.isGraphicsDebugOptionEnabled = needToShow
        guard self.emitter != nil else { return }

        self.view!.showsFPS = self.isGraphicsDebugOptionEnabled
        self.view!.showsNodeCount = self.isGraphicsDebugOptionEnabled
        self.view!.showsFields = self.isGraphicsDebugOptionEnabled
        self.view!.showsPhysics = self.isGraphicsDebugOptionEnabled
        self.view!.showsDrawCount = self.isGraphicsDebugOptionEnabled
    }
}
