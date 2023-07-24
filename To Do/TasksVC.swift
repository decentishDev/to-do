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
    var timeData: [Int] = []
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
                let editButton = UIButton()
                editButton.setTitle(String(format: "%02d:%02d", timeData[i] / 60, timeData[i] % 60), for: .normal)
                editButton.setTitleColor(.systemBlue, for: .normal)
                editButton.addTarget(self, action: #selector(self.editTimeButtonTapped(sender:)), for: .touchUpInside)
                transparentView.addSubview(editButton)
                editButton.translatesAutoresizingMaskIntoConstraints = false
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
                    textField.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -100),
                    
                    editButton.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor),
                    editButton.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -10)
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
            promptTask(animated: false)
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
        promptTask(animated: true)
    }
    func promptTask(animated: Bool){
        let alertController = UIAlertController(title: "New task", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let taskName = alertController.textFields?.first?.text {
                
                let timePickerVC = TimePickerViewController()
                timePickerVC.completionHandler = { hours, minutes in
                    self.timeData.append(minutes + (hours * 60))
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
                    
                    // Add an "Edit Time" button
                    let editButton = UIButton()
                    editButton.setTitle(String(format: "%02d:%02d", hours, minutes), for: .normal)
                    editButton.setTitleColor(.systemBlue, for: .normal)
                    editButton.addTarget(self, action: #selector(self.editTimeButtonTapped(sender:)), for: .touchUpInside)
                    transparentView.addSubview(editButton)
                    editButton.translatesAutoresizingMaskIntoConstraints = false
                    
                    let textField = UITextField()
                    textField.text = taskName
                    textField.textAlignment = .left
                    textField.font = UIFont.systemFont(ofSize: 20)
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
                        textField.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -100),
                        editButton.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor),
                        editButton.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -10)
                    ])
                    self.saveData()
                }
                
                let navigationController = UINavigationController(rootViewController: timePickerVC)
                self.present(navigationController, animated: true, completion: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: animated, completion: nil)
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
        var oldTimes: [[Int]] = defaults.object(forKey: "times") as! [[Int]]
        oldTimes[currentFolder] = timeData
        defaults.set(oldTimes, forKey: "times")
    }
    
    @objc func editTimeButtonTapped(sender: UIButton) {
        guard let taskDetailView = sender.superview else {
            return
        }
        
        let timeString = sender.currentTitle ?? ""
        let timeComponents = timeString.components(separatedBy: ":")
        
        if timeComponents.count == 2,
           let hours = Int(timeComponents[0]),
           let minutes = Int(timeComponents[1]) {
            let timePickerVC = TimePickerViewController()
            timePickerVC.completionHandler = { newHours, newMinutes in
                // Get the button from the taskDetailView and update the time
                sender.setTitle(String(format: "%02d:%02d", newHours, newMinutes), for: .normal)
                
                // Update the timeData array with the new time
                if let index = self.stackView.arrangedSubviews.firstIndex(of: taskDetailView) {
                    self.timeData[index / 2] = newMinutes + (newHours * 60)
                }
                self.saveData()
            }
            
            let navigationController = UINavigationController(rootViewController: timePickerVC)
            self.present(navigationController, animated: true, completion: nil)
        }
        saveData()
    }
}
        
extension TasksVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Two components for hours and minutes
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // Hours component
            return 24 // 0 to 23 hours
        } else { // Minutes component
            return 60 // 0 to 59 minutes
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { // Hours component
            return "\(row) hours"
        } else { // Minutes component
            return "\(row) minutes"
        }
    }
}
