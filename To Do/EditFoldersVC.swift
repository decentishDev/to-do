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
    var currentFolder = 0
    var titleName = ""
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    var stackIDs: [Int] = []
    var lastID = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = defaults.object(forKey: "data") as! [[String]]
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
                transparentView.addSubview(deleteButton)
                deleteButton.translatesAutoresizingMaskIntoConstraints = false
                
                let upButton = UIButton()
                upButton.setImage(UIImage(systemName: "arrow.up"), for: .normal)
                upButton.tintColor = .systemBlue
                upButton.addTarget(self, action: #selector(moveTaskUp), for: .touchUpInside)
                upButton.accessibilityIdentifier = String(i)
                transparentView.addSubview(upButton)
                upButton.translatesAutoresizingMaskIntoConstraints = false
                
                let downButton = UIButton()
                downButton.setImage(UIImage(systemName: "arrow.down"), for: .normal)
                downButton.tintColor = .systemBlue
                downButton.addTarget(self, action: #selector(moveTaskDown), for: .touchUpInside)
                downButton.accessibilityIdentifier = String(i)
                transparentView.addSubview(downButton)
                downButton.translatesAutoresizingMaskIntoConstraints = false
                
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
                    upButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
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
        
    }
    @objc func moveTaskDown(sender: UIButton){
        
    }
    @objc func deleteFolder(sender: UIButton) {
//        let index = stackIDs.firstIndex(of: Int(sender.accessibilityIdentifier!)!)!
//        let transparentView = stackView.arrangedSubviews[index * 2]
//        if(stackView.arrangedSubviews.count > 1){
//            let lineIndex = index * 2 + 1
//            if lineIndex < stackView.arrangedSubviews.count {
//                let lineView = stackView.arrangedSubviews[lineIndex]
//                lineView.removeFromSuperview()
//            }else{
//                let lineView = stackView.arrangedSubviews[lineIndex - 2]
//                lineView.removeFromSuperview()
//            }
//        }
//        transparentView.removeFromSuperview()
//        UIView.animate(withDuration: 0.3) {
//            self.stackView.layoutIfNeeded()
//        }
//        stackIDs.remove(at: stackIDs.firstIndex(of: Int(sender.accessibilityIdentifier!)!)!)
//        userData.remove(at: index)
//        saveData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        userData[stackIDs.firstIndex(of: Int(textField.accessibilityIdentifier!)!)!] = textField.text ?? " "
//        saveData()
        return true
    }
    func saveData(){
        defaults.set(userData, forKey: "data")
    }
}
