//
//  URToneCurveView.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 16..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

class URToneCurveView: UIView {
    @IBOutlet var view: UIView!

    @IBOutlet var graphView: URToneCurveGraphView!
    @IBOutlet var graphViewForRed: URToneCurveGraphView!
    @IBOutlet var graphViewForGreen: URToneCurveGraphView!
    @IBOutlet var graphViewForBlue: URToneCurveGraphView!
    @IBOutlet var btnApply: UIButton!
    @IBOutlet var btnRGB: URSelectableButton!
    @IBOutlet var btnRed: URSelectableButton!
    @IBOutlet var btnGreen: URSelectableButton!
    @IBOutlet var btnBlue: URSelectableButton!

    @IBOutlet var lbInput0: UILabel!
    @IBOutlet var lbInput1: UILabel!
    @IBOutlet var lbInput2: UILabel!
    @IBOutlet var lbInput3: UILabel!
    @IBOutlet var lbInput4: UILabel!

    var selectedGraphView: URToneCurveGraphView!

    var applyBlock: (() -> Void)?

    var vectorPoints: [CGPoint] {
        return self.graphView.curveRelativeVectorPoints
    }

    var vectorPointsForRed: [CGPoint] {
        return self.graphViewForRed.curveRelativeVectorPoints
    }

    var vectorPointsForGreen: [CGPoint] {
        return self.graphViewForGreen.curveRelativeVectorPoints
    }

    var vectorPointsForBlue: [CGPoint] {
        return self.graphViewForBlue.curveRelativeVectorPoints
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let _ = Bundle.main.loadNibNamed("URToneCurveView", owner: self, options: nil) else {
            fatalError("Loading Nib is failed!!")
        }
        self.addSubview(self.view)
        self.view.frame = self.bounds

        self.selectedGraphView = self.graphView
    }

    func initView() {
        self.layoutIfNeeded()

        self.btnApply.layer.cornerRadius = 4.0
        self.btnApply.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.btnApply.layer.borderWidth = 0.4

        self.btnRGB.layer.cornerRadius = 4.0
        self.btnRGB.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.btnRGB.layer.borderWidth = 0.4
        self.btnRGB.backgroundColorForNormal = self.btnRGB.titleColor(for: .selected)
        self.btnRGB.backgroundColorForSelected = self.btnRGB.titleColor(for: .normal)
        self.btnRGB.isSelected = true

        self.btnRed.layer.cornerRadius = 4.0
        self.btnRed.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.btnRed.layer.borderWidth = 0.4
        self.btnRed.backgroundColorForNormal = self.btnRed.titleColor(for: .selected)
        self.btnRed.backgroundColorForSelected = self.btnRed.titleColor(for: .normal)

        self.btnGreen.layer.cornerRadius = 4.0
        self.btnGreen.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.btnGreen.layer.borderWidth = 0.4
        self.btnGreen.backgroundColorForNormal = self.btnGreen.titleColor(for: .selected)
        self.btnGreen.backgroundColorForSelected = self.btnGreen.titleColor(for: .normal)

        self.btnBlue.layer.cornerRadius = 4.0
        self.btnBlue.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.btnBlue.layer.borderWidth = 0.4
        self.btnBlue.backgroundColorForNormal = self.btnBlue.titleColor(for: .selected)
        self.btnBlue.backgroundColorForSelected = self.btnBlue.titleColor(for: .normal)

        self.graphView.drawLine(true, needToInit: true)
        self.graphView.pointDidChanged = {
            self.setInputText()
        }

        self.graphViewForRed.rgbMode = .red
        self.graphViewForRed.drawLine(true, needToInit: true)
        self.graphViewForRed.pointDidChanged = {
            self.setInputText()
        }

        self.graphViewForGreen.rgbMode = .green
        self.graphViewForGreen.drawLine(true, needToInit: true)
        self.graphViewForGreen.pointDidChanged = {
            self.setInputText()
        }

        self.graphViewForBlue.rgbMode = .blue
        self.graphViewForBlue.drawLine(true, needToInit: true)
        self.graphViewForBlue.pointDidChanged = {
            self.setInputText()
        }
    }

    func setInputText(inputs: [CGPoint]! = nil) {
        var points: [CGPoint]! = inputs
        if inputs != nil {
            guard inputs.count == 5 else {
                fatalError("Input values count is not 5!!")
            }
        } else {
            switch self.selectedGraphView {
            case self.graphViewForRed:
                points = self.vectorPointsForRed
            case self.graphViewForGreen:
                points = self.vectorPointsForGreen
            case self.graphViewForBlue:
                points = self.vectorPointsForBlue
            default:
                points = self.vectorPoints
            }
        }

        DispatchQueue.main.async {
            self.lbInput0.text = URToneCurveUtil.pointToString(point: points[0])
            self.lbInput1.text = URToneCurveUtil.pointToString(point: points[1])
            self.lbInput2.text = URToneCurveUtil.pointToString(point: points[2])
            self.lbInput3.text = URToneCurveUtil.pointToString(point: points[3])
            self.lbInput4.text = URToneCurveUtil.pointToString(point: points[4])
        }
    }

    var applyInfoLabel: UILabel!
    @IBAction func tapApply(_ sender: Any) {
        print(#function)

        self.applyInfoLabel = UILabel()
        self.applyInfoLabel.isUserInteractionEnabled = true
        self.applyInfoLabel.numberOfLines = 0
        self.applyInfoLabel.backgroundColor = UIColor.white
        self.applyInfoLabel.lineBreakMode = .byWordWrapping
        self.applyInfoLabel.text = "RGB filter value is \(self.vectorPoints)\n"
            + "Red filter value is \(self.vectorPointsForRed)\n"
            + "Green filter value is \(self.vectorPointsForBlue)\n"
            + "Blue filter value is \(self.vectorPointsForGreen)\n"
        self.addSubview(self.applyInfoLabel)

        self.applyInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-15-[label]-15-|", options: [], metrics: nil, views: ["label" : self.applyInfoLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(-100)-[label(>=200)]", options: [], metrics: nil, views: ["label" : self.applyInfoLabel]))

        let labelGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAlertLabel(_:)))
        self.applyInfoLabel.addGestureRecognizer(labelGesture)

        let labelCopyGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleAlertLabelLongTap(_:)))
        self.applyInfoLabel.addGestureRecognizer(labelCopyGesture)

        guard let block = self.applyBlock else { return }
        block()

        self.tapRGB(nil)
    }

    func handleAlertLabel(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            self.applyInfoLabel.removeFromSuperview()
        }
    }

    func handleAlertLabelLongTap(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            self.applyInfoLabel.removeFromSuperview()
        }
    }

    @IBAction func tapRGB(_ sender: Any?) {
        self.btnRGB.isSelected = true
        self.btnRed.isSelected = false
        self.btnGreen.isSelected = false
        self.btnBlue.isSelected = false

        self.graphView.isHidden = false
//        self.graphViewForRed.isHidden = true
//        self.graphViewForGreen.isHidden = true
//        self.graphViewForBlue.isHidden = true

        self.view.sendSubview(toBack: self.graphViewForBlue)
        self.view.sendSubview(toBack: self.graphViewForGreen)
        self.view.sendSubview(toBack: self.graphViewForRed)
        self.view.bringSubview(toFront: self.graphView)

        self.selectedGraphView = self.graphView
    }

    @IBAction func tapRed(_ sender: Any) {
        self.btnRGB.isSelected = false
        self.btnRed.isSelected = true
        self.btnGreen.isSelected = false
        self.btnBlue.isSelected = false

//        self.graphView.isHidden = true
        self.graphViewForRed.isHidden = false
//        self.graphViewForGreen.isHidden = true
//        self.graphViewForBlue.isHidden = true

        self.view.sendSubview(toBack: self.graphViewForBlue)
        self.view.sendSubview(toBack: self.graphViewForGreen)
        self.view.bringSubview(toFront: self.graphViewForRed)
        self.view.sendSubview(toBack: self.graphView)

        self.selectedGraphView = self.graphViewForRed
    }

    @IBAction func tapGreen(_ sender: Any) {
        self.btnRGB.isSelected = false
        self.btnRed.isSelected = false
        self.btnGreen.isSelected = true
        self.btnBlue.isSelected = false

//        self.graphView.isHidden = true
//        self.graphViewForRed.isHidden = true
        self.graphViewForGreen.isHidden = false
//        self.graphViewForBlue.isHidden = true

        self.view.sendSubview(toBack: self.graphViewForBlue)
        self.view.bringSubview(toFront: self.graphViewForGreen)
        self.view.sendSubview(toBack: self.graphViewForRed)
        self.view.sendSubview(toBack: self.graphView)

        self.selectedGraphView = self.graphViewForGreen
    }

    @IBAction func tapBlue(_ sender: Any) {
        self.btnRGB.isSelected = false
        self.btnRed.isSelected = false
        self.btnGreen.isSelected = false
        self.btnBlue.isSelected = true

//        self.graphView.isHidden = true
//        self.graphViewForRed.isHidden = true
//        self.graphViewForGreen.isHidden = true
        self.graphViewForBlue.isHidden = false

        self.view.bringSubview(toFront: self.graphViewForBlue)
        self.view.sendSubview(toBack: self.graphViewForGreen)
        self.view.sendSubview(toBack: self.graphViewForRed)
        self.view.sendSubview(toBack: self.graphView)

        self.selectedGraphView = self.graphViewForBlue
    }

}

class URSelectableButton: UIButton {
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue

            if newValue {
                self.backgroundColor = self.backgroundColorForSelected
            } else {
                self.backgroundColor = self.backgroundColorForNormal
            }
        }
    }

    var backgroundColorForNormal: UIColor?
    var backgroundColorForSelected: UIColor?
}
