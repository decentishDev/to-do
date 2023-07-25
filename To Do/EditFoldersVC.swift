//
//  EditFoldersVC.swift
//  To Do
//
//  Created by Matthew Lundeen on 3/27/23.
//

import UIKit

class EditFoldersVC: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    var userData: [[String]] = [[]]
    var timeData: [[Int]] = [[]]
    var currentFolder = 0
    var titleName = ""
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    var downButtons: [UIButton] = []
    var upButtons: [UIButton] = []
    var stackIDs: [Int] = []
    var lastID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = defaults.object(forKey: "data") as! [[String]]
        timeData = defaults.object(forKey: "times") as! [[Int]]
        title = titleName
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])
        if(userData.count > 0){
            for i in 0...(userData.count - 1) {
                let transparentView = UIView()
                transparentView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
                transparentView.layer.cornerRadius = 10
                stackView.addArrangedSubview(transparentView)
                
                let deleteButton = UIButton()
                deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
                deleteButton.tintColor = .red
                deleteButton.addTarget(self, action: #selector(deleteFolder), for: .touchUpInside)
                deleteButton.accessibilityIdentifier = String(i)
                stackIDs.append(i)
                transparentView.addSubview(deleteButton)
                deleteButton.translatesAutoresizingMaskIntoConstraints = false
                
                let upButton = UIButton()
                upButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
                upButton.tintColor = .systemBlue
                upButton.addTarget(self, action: #selector(moveTaskUp), for: .touchUpInside)
                upButton.accessibilityIdentifier = String(i)
                transparentView.addSubview(upButton)
                upButton.translatesAutoresizingMaskIntoConstraints = false
                upButtons.append(upButton)
                if(i == 0){
                    upButton.isEnabled = false
                }
                
                let downButton = UIButton()
                downButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
                downButton.tintColor = .systemBlue
                downButton.addTarget(self, action: #selector(moveTaskDown), for: .touchUpInside)
                downButton.accessibilityIdentifier = String(i)
                transparentView.addSubview(downButton)
                downButton.translatesAutoresizingMaskIntoConstraints = false
                downButtons.append(downButton)
                if(i == userData.count - 1){
                    downButton.isEnabled = false
                }
                
                let textField = UITextField()
                textField.text = userData[i][0]
                textField.font = UIFont.systemFont(ofSize: 20)
                textField.textAlignment = .left
                textField.accessibilityIdentifier = String(i)
                transparentView.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                textField.delegate = self
                
                NSLayoutConstraint.activate([
                    deleteButton.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor),
                    deleteButton.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -10),
                    deleteButton.widthAnchor.constraint(equalToConstant: 25),
                    deleteButton.heightAnchor.constraint(equalToConstant: 25),
                    
                    upButton.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 10),
                    upButton.trailingAnchor.constraint(equalTo: downButton.leadingAnchor, constant: -10),
                    upButton.widthAnchor.constraint(equalToConstant: 25),
                    upButton.heightAnchor.constraint(equalToConstant: 25),
                    
                    downButton.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -10),
                    downButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
                    downButton.widthAnchor.constraint(equalToConstant: 25),
                    downButton.heightAnchor.constraint(equalToConstant: 25),
                    
                    textField.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 10),
                    textField.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -10),
                    textField.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 10),
                    textField.trailingAnchor.constraint(equalTo: upButton.leadingAnchor, constant: -10)
                ])
            }
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
                stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
                stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
                stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor) // Add this constraint
            ])
        }
    }
    @objc func moveTaskUp(sender: UIButton){
        let index = upButtons.firstIndex(of: sender)!
        
        let ubutton = upButtons[index]
        upButtons[index] = upButtons[index - 1]
        upButtons[index - 1] = ubutton
        
        let dbutton = downButtons[index]
        downButtons[index] = downButtons[index - 1]
        downButtons[index - 1] = dbutton
        
        let group = userData[index]
        userData[index] = userData[index - 1]
        userData[index - 1] = group
        
        let time = timeData[index]
        timeData[index] = timeData[index - 1]
        timeData[index - 1] = time
        
        let id = stackIDs[index]
        stackIDs[index] = stackIDs[index - 1]
        stackIDs[index - 1] = id
        
        let transparentView = stackView.arrangedSubviews[index]
        stackView.removeArrangedSubview(transparentView)
        stackView.insertArrangedSubview(transparentView, at: index - 1)
        if(index == userData.count - 1){
            downButtons[index - 1].isEnabled = true
            downButtons[index].isEnabled = false
        }
        if(index == 1){
            upButtons[index - 1].isEnabled = false
            upButtons[index].isEnabled = true
        }
    }
    @objc func moveTaskDown(sender: UIButton) {
        let index = downButtons.firstIndex(of: sender)!
        
        let ubutton = upButtons[index + 1]
        upButtons[index + 1] = upButtons[index]
        upButtons[index] = ubutton
        
        let dbutton = downButtons[index + 1]
        downButtons[index + 1] = downButtons[index]
        downButtons[index] = dbutton
        
        let group = userData[index + 1]
        userData[index + 1] = userData[index]
        userData[index] = group
        
        let time = timeData[index + 1]
        timeData[index + 1] = timeData[index]
        timeData[index] = time
        
        let id = stackIDs[index + 1]
        stackIDs[index + 1] = stackIDs[index]
        stackIDs[index] = id
        
        let transparentView = stackView.arrangedSubviews[index]
        stackView.removeArrangedSubview(transparentView)
        stackView.insertArrangedSubview(transparentView, at: index + 1)
        
        if index == 0 {
            upButtons[index].isEnabled = true
            upButtons[index + 1].isEnabled = false
        }
        
        if index == userData.count - 2 {
            downButtons[index].isEnabled = false
            downButtons[index + 1].isEnabled = true
        }
    }

    @objc func deleteFolder(sender: UIButton) {
        let index = stackIDs.firstIndex(of: Int(sender.accessibilityIdentifier!)!)!
        let transparentView = stackView.arrangedSubviews[index]
        transparentView.removeFromSuperview()
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
        stackIDs.remove(at: stackIDs.firstIndex(of: Int(sender.accessibilityIdentifier!)!)!)
        userData.remove(at: index)
        timeData.remove(at: index)
        upButtons.remove(at: index)
        downButtons.remove(at: index)
        upButtons[index].isEnabled = (index == 0)
        downButtons[index].isEnabled = (index == userData.count - 1)
        saveData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        userData[stackIDs.firstIndex(of: Int(textField.accessibilityIdentifier!)!)!][1] = textField.text ?? " "
        saveData()
        return true
    }
    func saveData(){
        defaults.set(userData, forKey: "data")
        defaults.set(timeData, forKey: "times")
    }
}
