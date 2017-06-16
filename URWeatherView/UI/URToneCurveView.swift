//
//  URToneCurveView.swift
//  URWeatherView
//
//  Created by DongSoo Lee on 2017. 5. 16..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit

open class URToneCurveView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

    @IBOutlet var btnOpenFile: UIButton!

    var selectedGraphView: URToneCurveGraphView! {
        didSet {
            self.setInputText()
        }
    }

    open var setImageBlock: ((UIImage) -> Void)?
    open var applyBlock: ((String) -> Void)?
    open var parentViewController: UIViewController!

    open var vectorPoints: [CGPoint] {
        return self.graphView.curveRelativeVectorPoints
    }

    open var vectorPointsForRed: [CGPoint] {
        return self.graphViewForRed.curveRelativeVectorPoints
    }

    open var vectorPointsForGreen: [CGPoint] {
        return self.graphViewForGreen.curveRelativeVectorPoints
    }

    open var vectorPointsForBlue: [CGPoint] {
        return self.graphViewForBlue.curveRelativeVectorPoints
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "URToneCurveView", bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)

        self.addSubview(self.view)
        self.view.frame = self.bounds

        self.selectedGraphView = self.graphView
    }

    open func initView() {
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

        self.btnOpenFile.layer.cornerRadius = 4.0
        self.btnOpenFile.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor
        self.btnOpenFile.layer.borderWidth = 0.4

        self.graphView.drawLine(true, needToInit: true)
        self.graphView.pointDidChanged = {
            self.setInputText()

            DispatchQueue.main.async {
                guard let block = self.applyBlock else { return }
                block("RGB filter value :\n\(self.vectorPoints)\n"
                    + "Red filter value :\n\(self.vectorPointsForRed)\n"
                    + "Green filter value :\n\(self.vectorPointsForGreen)\n"
                    + "Blue filter value :\n\(self.vectorPointsForBlue)\n")
            }
        }

        self.graphViewForRed.rgbMode = .red
        self.graphViewForRed.drawLine(true, needToInit: true)
        self.graphViewForRed.pointDidChanged = {
            self.setInputText()

            DispatchQueue.main.async {
                guard let block = self.applyBlock else { return }
                block("RGB filter value :\n\(self.vectorPoints)\n"
                    + "Red filter value :\n\(self.vectorPointsForRed)\n"
                    + "Green filter value :\n\(self.vectorPointsForGreen)\n"
                    + "Blue filter value :\n\(self.vectorPointsForBlue)\n")
            }
        }

        self.graphViewForGreen.rgbMode = .green
        self.graphViewForGreen.drawLine(true, needToInit: true)
        self.graphViewForGreen.pointDidChanged = {
            self.setInputText()

            DispatchQueue.main.async {
                guard let block = self.applyBlock else { return }
                block("RGB filter value :\n\(self.vectorPoints)\n"
                    + "Red filter value :\n\(self.vectorPointsForRed)\n"
                    + "Green filter value :\n\(self.vectorPointsForGreen)\n"
                    + "Blue filter value :\n\(self.vectorPointsForBlue)\n")
            }
        }

        self.graphViewForBlue.rgbMode = .blue
        self.graphViewForBlue.drawLine(true, needToInit: true)
        self.graphViewForBlue.pointDidChanged = {
            self.setInputText()

            DispatchQueue.main.async {
                guard let block = self.applyBlock else { return }
                block("RGB filter value :\n\(self.vectorPoints)\n"
                    + "Red filter value :\n\(self.vectorPointsForRed)\n"
                    + "Green filter value :\n\(self.vectorPointsForGreen)\n"
                    + "Blue filter value :\n\(self.vectorPointsForBlue)\n")
            }
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
            self.lbInput0.text = URFilterUtil.pointToString(point: points[0])
            self.lbInput1.text = URFilterUtil.pointToString(point: points[1])
            self.lbInput2.text = URFilterUtil.pointToString(point: points[2])
            self.lbInput3.text = URFilterUtil.pointToString(point: points[3])
            self.lbInput4.text = URFilterUtil.pointToString(point: points[4])
        }
    }

    var applyInfoLabel: UILabel!
    @IBAction func tapApply(_ sender: Any) {
        print(#function)

        guard let block = self.applyBlock else { return }
        block("[\"RGB\": [\(self.vectorPoints)]]\n"
            + "[\"R\": [\(self.vectorPointsForRed)]]\n"
            + "[\"G\": [\(self.vectorPointsForGreen)]]\n"
            + "[\"B\": [\(self.vectorPointsForBlue)]]\n")

        self.tapRGB(nil)
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

    @IBAction func tapOpenFile(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.parentViewController.present(picker, animated: true, completion: nil)
    }

    @IBOutlet var swBoxPerCurve: UISwitch!
    @IBOutlet var swBoxPerDot: UISwitch!
    @IBAction func changedValue(_ sender: Any) {
        guard let sw: UISwitch = sender as? UISwitch else { return }
        switch sw {
        case self.swBoxPerCurve:
            self.graphView.isShowCurveArea = self.swBoxPerCurve.isOn
            self.graphViewForRed.isShowCurveArea = self.swBoxPerCurve.isOn
            self.graphViewForGreen.isShowCurveArea = self.swBoxPerCurve.isOn
            self.graphViewForBlue.isShowCurveArea = self.swBoxPerCurve.isOn
        case self.swBoxPerDot:
            self.graphView.isShowAreaBetweenDots = self.swBoxPerDot.isOn
            self.graphViewForRed.isShowAreaBetweenDots = self.swBoxPerDot.isOn
            self.graphViewForGreen.isShowAreaBetweenDots = self.swBoxPerDot.isOn
            self.graphViewForBlue.isShowAreaBetweenDots = self.swBoxPerDot.isOn
        default:
            break
        }
    }

    // MARK: - UIImagePickerControllerDelegate
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info is \(info)")

        defer {
            picker.dismiss(animated: true, completion: nil)
        }

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let block = self.setImageBlock else { return }
        block(image)
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
