//
//  ToneCurveGraphView.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 11..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class ToneCurveGraphView: UIView {
    var tapGesture: UITapGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initView()
    }

    func initView() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)

        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(self.tapGesture)

        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(self.panGesture)
    }

    func handleTap(_ gesture: UITapGestureRecognizer) {
        print(#function)
    }

    var preLocation: CGPoint = .zero

    func handlePan(_ gesture: UIPanGestureRecognizer) {
        print(#function)

        var position: CGPoint = .zero

        switch gesture.state {
        case .began:
            position = gesture.location(in: self)
            print("at the beginning : \(position)")
        case .changed:
            let changedPosition: CGPoint = gesture.translation(in: self)
            print("at changing : \(changedPosition)")
        case .ended, .cancelled, .failed:
            //
            print("at the end")
        default:
            break
        }

        self.preLocation = position
    }

    func drawLine() {

    }
}
