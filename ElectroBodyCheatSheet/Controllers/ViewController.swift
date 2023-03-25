//
//  ViewController.swift
//  ElectroBodyCheatSheet
//
//  Created by Adam on 24/03/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var letterImage: UIImageView!
    @IBOutlet weak var teleporterImage: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    
    var timer = Timer()
    var animationFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.window?.overrideUserInterfaceStyle = .dark
        
        teleporterImage.alpha = 0
        
        picker.dataSource = self
        picker.delegate = self
    }

    func teleporterAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(updateTeleporter), userInfo: nil, repeats: true)
    }
    
    @objc func updateTeleporter() {
        if animationFlag {
            if teleporterImage.alpha == 1 {
                teleporterImage.alpha = 0
            } else {
                teleporterImage.alpha = 1
            }
        } else {
            timer.invalidate()
            teleporterImage.alpha = 0
        }
    }

}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return Codes.page.count
        case 1:
            return Codes.paragraph.count
        case 2:
            return Codes.word.count
        default:
            return Codes.letter.count
        }
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        
        switch component {
        case 0:
            myImageView.image = UIImage(named: "\(Codes.page[row])")
        case 1:
            myImageView.image = UIImage(named: "\(Codes.paragraph[row])")
        case 2:
            myImageView.image = UIImage(named: "\(Codes.word[row])")
        default:
            myImageView.image = UIImage(named: "\(Codes.letter[row])")
        }
        
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(Codes.page[row])"
        case 1:
            return "\(Codes.paragraph[row])"
        case 2:
            return "\(Codes.word[row])"
        default:
            return "\(Codes.letter[row])"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pageSelected = Codes.page[pickerView.selectedRow(inComponent: 0)]
        let paragraphSelected = Codes.paragraph[pickerView.selectedRow(inComponent: 1)]
        let wordSelected = Codes.word[pickerView.selectedRow(inComponent: 2)]
        let letterSelected = Codes.letter[pickerView.selectedRow(inComponent: 3)]
        
        let codeSelected = "\(pageSelected) \(paragraphSelected) \(wordSelected) \(letterSelected)"
        
        timer.invalidate()
        if let safeImageName = Codes.answers[codeSelected] {
            animationFlag = true
            teleporterAnimation()
            letterImage.image = UIImage(named: safeImageName)!
        } else {
            animationFlag = false
            letterImage.image = UIImage(named: "questionMark")!
        }
    }
}
