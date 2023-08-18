//
//  SetupVC.swift
//  To Do
//
//  Created by Matthew Lundeen on 7/31/23.
//

import UIKit

class SetupVC: UIViewController {

    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var BackgroundImage2: UIImageView!
    @IBOutlet weak var BackgroundImage3: UIImageView!
    
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var Page1: UIView!
    @IBOutlet weak var Page2: UIView!
    
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        BackgroundImage2.translatesAutoresizingMaskIntoConstraints = false
        BackgroundImage3.translatesAutoresizingMaskIntoConstraints = false
        let parentLength = max(view.bounds.width, view.bounds.height)
        let parentWidth = min(view.bounds.width, view.bounds.height)
        let newLength = parentLength * 2
        let newWidth = parentWidth * 2
        NSLayoutConstraint.activate([
            BackgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            BackgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            BackgroundImage.widthAnchor.constraint(equalToConstant: newWidth),
            BackgroundImage.heightAnchor.constraint(equalToConstant: newLength),
            
            BackgroundImage2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            BackgroundImage2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            BackgroundImage2.widthAnchor.constraint(equalToConstant: newWidth),
            BackgroundImage2.heightAnchor.constraint(equalToConstant: newLength),
            
            BackgroundImage3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            BackgroundImage3.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            BackgroundImage3.widthAnchor.constraint(equalToConstant: newWidth),
            BackgroundImage3.heightAnchor.constraint(equalToConstant: newLength),
        ])
        backgroundRotate()
        Page1.layer.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        Page2.layer.position = CGPoint(x: UIScreen.main.bounds.width * 1.5, y: UIScreen.main.bounds.height * 0.5)
        BackButton.isEnabled = false
    }
    
    func backgroundRotate(){
        UIView.animate(withDuration: 3, animations: {
            self.BackgroundImage.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0..<360))
            self.BackgroundImage2.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0..<360))
            self.BackgroundImage3.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0..<360))
            self.BackgroundImage.alpha = CGFloat.random(in: 0..<1)
            self.BackgroundImage2.alpha = CGFloat.random(in: 0..<1)
            self.BackgroundImage3.alpha = CGFloat.random(in: 0..<1)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.backgroundRotate()
        }
    }

    @IBAction func ExitSetup(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        print("next")
        currentPage += 1
        if(currentPage == 2){
            NextButton.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.Page1.layer.position = CGPoint(x: -1 *  UIScreen.main.bounds.width * 1.5, y: UIScreen.main.bounds.height * 0.5)
                self.Page2.layer.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
            })
        }
        BackButton.isEnabled = true
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        print("back")
        currentPage -= 1
        if(currentPage == 1){
            BackButton.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.Page1.layer.position = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
                self.Page2.layer.position = CGPoint(x: UIScreen.main.bounds.width * 1.5, y: UIScreen.main.bounds.height * 0.5)
            })
        }
        NextButton.isEnabled = true
    }
}
