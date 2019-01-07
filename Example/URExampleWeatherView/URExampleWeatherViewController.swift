//
//  URExampleWeatherViewController.swift
//  URExampleWeatherView
//
//  Created by DongSoo Lee on 2017. 6. 19..
//  Copyright © 2017년 zigbang. All rights reserved.
//

import UIKit
import URWeatherView

class URExampleWeatherViewController: UIViewController {

    @IBOutlet var mainView: URWeatherView!
    @IBOutlet var btnOne: UIButton!
    @IBOutlet var btnTwo: UIButton!

    @IBOutlet var segment: UISegmentedControl!

    @IBOutlet var effectTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.mainView.initView(dataNameOfLottie: "data", backgroundImage: #imageLiteral(resourceName: "img_back"))

        self.mainView.initView(mainWeatherImage: #imageLiteral(resourceName: "buildings"), backgroundImage: #imageLiteral(resourceName: "bluesky.en"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tabOne(_ sender: Any) {
        if !self.btnOne.isSelected {
            self.btnOne.isSelected = true
            self.btnTwo.isSelected = false

            self.mainView.play()

            self.changedMainState()
        }
    }

    @IBAction func tabTwo(_ sender: Any) {
        if !self.btnTwo.isSelected {
            self.btnOne.isSelected = false
            self.btnTwo.isSelected = true

            self.mainView.play(eventHandler: {
                Timer.scheduledTimer(timeInterval: 0.32, target: self, selector: #selector(self.handleLottieAnimation), userInfo: nil, repeats: false)
            })
        }
    }

    @objc func handleLottieAnimation() {
        self.mainView.pause()

        self.changedMainState()
    }

    @IBAction func changeSpriteKitDebugOption(_ sender: Any) {
        if let segment = sender as? UISegmentedControl {
            let selected: Bool = segment.selectedSegmentIndex == 0
            self.mainView.enableDebugOption = selected
        }
    }
}

extension URExampleWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URWeatherType.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if URWeatherType.all[indexPath.row] == .dust ||
            URWeatherType.all[indexPath.row] == .dust2  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "effectCell2", for: indexPath) as! URExampleWeatherTableViewCell2

            cell.configCell(URWeatherType.all[indexPath.row])

            cell.applyWeatherBlock = {
                switch cell.weather {
                case .dust, .dust2:
                    if cell.btnDustColor1.isSelected {
                        self.mainView.startWeatherSceneBulk(.dust, debugOption: self.segment.selectedSegmentIndex == 0, additionalTask: {
                            if let startBirthRate = cell.weather.startBirthRate {
                                cell.slBirthRate.value = Float(startBirthRate)
                                cell.changeBirthRate(cell.slBirthRate)
                            }
                        })
                    }
                    if cell.btnDustColor2.isSelected {
                        self.mainView.startWeatherSceneBulk(.dust2, debugOption: self.segment.selectedSegmentIndex == 0, additionalTask: {
                            if let startBirthRate = cell.weather.startBirthRate {
                                cell.slBirthRate.value = Float(startBirthRate)
                                cell.changeBirthRate(cell.slBirthRate)
                            }
                        })
                    }
                default:
                    break
                }
            }

            cell.stopWeatherBlock = {
                self.mainView.stop()
            }

            cell.birthRateDidChange = { (birthRate) in
                self.mainView.birthRate = birthRate
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "effectCell1", for: indexPath) as! URExampleWeatherTableViewCell
            cell.configCell(URWeatherType.all[indexPath.row])

            cell.applyWeatherBlock = {
                switch cell.weather {
                case .snow:
                    self.mainView.startWeatherSceneBulk(cell.weather, debugOption: self.segment.selectedSegmentIndex == 0, additionalTask: {
                        self.changedMainState()
                    })
                case .rain:
                    self.mainView.startWeatherSceneBulk(cell.weather, debugOption: self.segment.selectedSegmentIndex == 0, additionalTask: {
                        self.changedMainState()
                    })
                case .lightning, .hot, .comet:
                    self.mainView.startWeatherSceneBulk(cell.weather, debugOption: self.segment.selectedSegmentIndex == 0)
                case .cloudy:
//                    self.mainView.startWeatherSceneBulk(cell.weather, duration: 33.0, debugOption: self.segment.selectedSegmentIndex == 0)

                    self.mainView.initWeather()
                    self.mainView.setUpperImageEffect(customImage: nil)
                    let option = UREffectCloudOption(CGRect(x: 0.0, y: 0.5, width: 1.0, height: 0.5), angleInDegree: 0.0, movingDuration: 33.0)
                    self.mainView.startWeatherScene(cell.weather, duration: 33.0, userInfo: [URWeatherKeyCloudOption: option])
                default:
                    self.mainView.setUpperImageEffect()

                    self.mainView.stop()
                    self.mainView.enableDebugOption = self.segment.selectedSegmentIndex == 0
                }
            }

            cell.stopWeatherBlock = {
                self.mainView.stop()
            }

            cell.birthRateDidChange = { (birthRate) in
                self.mainView.birthRate = birthRate
            }

            return cell
        }
    }

    func changedMainState() {
        let sceneSize: CGSize = self.mainView.weatherSceneSize
        switch self.mainView.weatherType {
        case .snow:
            if self.btnOne.isSelected {
                self.mainView.weatherGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.290, y: sceneSize.height * 0.572)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.237, y: sceneSize.height * 0.530)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.188, y: sceneSize.height * 0.484)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.101, y: sceneSize.height * 0.475), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.752, y: sceneSize.height * 0.748), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.829, y: sceneSize.height * 0.602), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.663, y: sceneSize.height * 0.556), rangeRatio: 0.078, degree: -27.0)]
            } else {
                let diffY: CGFloat = 0.07
                self.mainView.weatherGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.290, y: sceneSize.height * (0.572 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.237, y: sceneSize.height * (0.530 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.188, y: sceneSize.height * (0.484 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.101, y: sceneSize.height * (0.475 - diffY)), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.752, y: sceneSize.height * (0.748 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.829, y: sceneSize.height * (0.602 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.663, y: sceneSize.height * (0.556 + diffY)), rangeRatio: 0.078, degree: -27.0)]
            }
        case .rain:
            if self.btnOne.isSelected {
                self.mainView.weatherGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.290, y: sceneSize.height * 0.572)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.237, y: sceneSize.height * 0.530)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.188, y: sceneSize.height * 0.484)),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.101, y: sceneSize.height * 0.475), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.752, y: sceneSize.height * 0.748), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.829, y: sceneSize.height * 0.602), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.663, y: sceneSize.height * 0.556), rangeRatio: 0.078, degree: -27.0)]
            } else {
                let diffY: CGFloat = 0.07
                self.mainView.weatherGroundEmitterOptions = [URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.307, y: sceneSize.height * (0.590 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.261, y: sceneSize.height * (0.544 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.208, y: sceneSize.height * (0.497 - diffY))),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.122, y: sceneSize.height * (0.481 - diffY)), rangeRatio: 0.042),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.778, y: sceneSize.height * (0.761 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.855, y: sceneSize.height * (0.614 + diffY)), rangeRatio: 0.094, degree: -27.0),
                                                             URWeatherGroundEmitterOption(position: CGPoint(x: sceneSize.width * 0.684, y: sceneSize.height * (0.565 + diffY)), rangeRatio: 0.078, degree: -27.0)]
            }
        default:
            break
        }
    }
}
