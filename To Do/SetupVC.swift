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
}
