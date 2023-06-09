//
//  TasksVC.swift
//  To Do
//
//  Created by Matthew Lundeen on 3/25/23.
//

import UIKit

class TasksVC: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    var userData: [String] = []
    var currentFolder = 0
    var titleName = ""
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    var stackIDs: [Int] = []
    var lastID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
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
                transparentView.backgroundColor = UIColor.clear
                transparentView.layer.cornerRadius = 10
                stackView.addArrangedSubview(transparentView)
                let circleButton = UIButton()
                circleButton.backgroundColor = .clear
                circleButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
                circleButton.layer.borderWidth = 1
                circleButton.layer.cornerRadius = 12.5
                circleButton.addTarget(self, action: #selector(checked), for: .touchUpInside)
                circleButton.accessibilityIdentifier = String(i)
                stackIDs.append(i)
                lastID = i
                transparentView.addSubview(circleButton)
                circleButton.translatesAutoresizingMaskIntoConstraints = false
                let textField = UITextField()
                textField.text = userData[i]
                textField.font = UIFont.systemFont(ofSize: 20)
                textField.textAlignment = .left
                textField.accessibilityIdentifier = String(i)
                transparentView.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                textField.delegate = self
                NSLayoutConstraint.activate([
                    circleButton.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 10),
                    circleButton.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 10),
                    circleButton.widthAnchor.constraint(equalToConstant: 25),
                    circleButton.heightAnchor.constraint(equalToConstant: 25),
                    
                    textField.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 10),
                    textField.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -10),
                    textField.leadingAnchor.constraint(equalTo: circleButton.trailingAnchor, constant: 10),
                    textField.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -10)
                ])
                if i < userData.count - 1 {
                    let lineView = UIView()
                    lineView.backgroundColor = UIColor.placeholderText
                    stackView.addArrangedSubview(lineView)
                    lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
                }
            }
        }
        if(userData.count == 0){
            promptTask()
        }
    }
    @objc func checked(sender: UIButton) {
        let index = stackIDs.firstIndex(of: Int(sender.accessibilityIdentifier!)!)!
        let transparentView = stackView.arrangedSubviews[index * 2]
        if(stackView.arrangedSubviews.count > 1){
            let lineIndex = index * 2 + 1
            if lineIndex < stackView.arrangedSubviews.count {
                let lineView = stackView.arrangedSubviews[lineIndex]
                lineView.removeFromSuperview()
            }else{
                let lineView = stackView.arrangedSubviews[lineIndex - 2]
                lineView.removeFromSuperview()
            }
        }
        transparentView.removeFromSuperview()
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
        stackIDs.remove(at: stackIDs.firstIndex(of: Int(sender.accessibilityIdentifier!)!)!)
        userData.remove(at: index)
        saveData()
    }
    @IBAction func AddTask(_ sender: UIBarButtonItem) {
        promptTask()
    }
    func promptTask(){
        let alertController = UIAlertController(title: "New task", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let taskName = alertController.textFields?.first?.text {
                if(self.stackView.arrangedSubviews.count > 0){
                    let lineView = UIView()
                    lineView.backgroundColor = UIColor.placeholderText
                    self.stackView.addArrangedSubview(lineView)
                    lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
                }
                self.userData.append(taskName)
                self.lastID += 1
                self.stackIDs.append(self.lastID)
                let transparentView = UIView()
                transparentView.backgroundColor = UIColor.clear
                transparentView.layer.cornerRadius = 10
                self.stackView.addArrangedSubview(transparentView)
                let circleButton = UIButton()
                circleButton.backgroundColor = .clear
                circleButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
                circleButton.layer.borderWidth = 1
                circleButton.layer.cornerRadius = 12.5
                circleButton.addTarget(self, action: #selector(self.checked), for: .touchUpInside)
                circleButton.accessibilityIdentifier = String(self.lastID)
                transparentView.addSubview(circleButton)
                circleButton.translatesAutoresizingMaskIntoConstraints = false
                
                let textField = UITextField()
                textField.text = taskName
                textField.textAlignment = .left
                textField.accessibilityIdentifier = String(self.lastID)
                transparentView.addSubview(textField)
                textField.translatesAutoresizingMaskIntoConstraints = false
                textField.delegate = self
                NSLayoutConstraint.activate([
                    circleButton.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 10),
                    circleButton.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 10),
                    circleButton.widthAnchor.constraint(equalToConstant: 25),
                    circleButton.heightAnchor.constraint(equalToConstant: 25),
                    textField.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 10),
                    textField.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -10),
                    textField.leadingAnchor.constraint(equalTo: circleButton.trailingAnchor, constant: 10),
                    textField.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -10)
                ])
                self.saveData()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        userData[stackIDs.firstIndex(of: Int(textField.accessibilityIdentifier!)!)!] = textField.text ?? " "
        saveData()
        return true
    }
    func saveData(){
        var oldData: [[String]] = defaults.object(forKey: "data") as! [[String]]
        var newData: [String] = userData
        newData.insert(titleName, at: 0)
        oldData[currentFolder] = newData
        defaults.set(oldData, forKey: "data")
    }
}
