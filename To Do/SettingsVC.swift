//
//  SettingsVC.swift
//  To Do
//
//  Created by Matthew Lundeen on 7/25/23.
//

import UIKit

class SettingsVC: UIViewController {
    let stackView = UIStackView()
    let defaults = UserDefaults.standard
    var settings: [String: Bool] = [:]
    let settingsLayout: [[String]] = [["h", "General settings"], ["c"], ["h", "Inbox"], ["b", "Show times", "inbox.showTimes"], ["h", "Groups"], ["b", "Show times", "groups.showTimes"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorTheme.background
        if let tryData = defaults.object(forKey: "settings") as? [String: Bool] {
            settings = tryData
        }else{
            settings = [
                "inbox.showTimes": false,
                "groups.showTimes": true,
                "key3": true,
            ]
            defaults.set(settings, forKey: "settings")
        }
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill

        let scrollView = UIScrollView()
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -0),
        ])
        
        for i in settingsLayout {
            if(i[0] == "h"){
                let inboxLabel = UILabel()
                inboxLabel.text = i[1]
                inboxLabel.font = UIFont.boldSystemFont(ofSize: 30)
                inboxLabel.textAlignment = .left
                inboxLabel.textColor = ColorTheme.label
                inboxLabel.backgroundColor = .clear
                inboxLabel.sizeToFit()
                stackView.addArrangedSubview(inboxLabel)
            }else if(i[0] == "b"){
                let titleView = UIView()
                titleView.backgroundColor = .clear
                stackView.addArrangedSubview(titleView)
                
                let titleLabel = UILabel()
                titleLabel.text = "Show times"
                titleLabel.font = UIFont.systemFont(ofSize: 22)
                titleLabel.textAlignment = .left
                titleLabel.textColor = ColorTheme.label
                titleLabel.sizeToFit()
                
                let switchView = UISwitch()
                let labelsStackView = UIStackView(arrangedSubviews: [switchView, titleLabel])
                
                labelsStackView.axis = .horizontal
                labelsStackView.spacing = 15
                labelsStackView.alignment = .leading
                labelsStackView.sizeToFit()
                labelsStackView.distribution = .fillProportionally
                
                titleView.addSubview(labelsStackView)
                titleView.backgroundColor = .clear
                
                labelsStackView.sizeToFit()
                
                titleView.sizeToFit()
                
                labelsStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    labelsStackView.topAnchor.constraint(equalTo: titleView.topAnchor),
                    labelsStackView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
                    labelsStackView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
                    titleLabel.centerYAnchor.constraint(equalTo: labelsStackView.centerYAnchor),
                ])
            }else if(i[0] == "c"){
                // Create the segmented control
                let segmentedControl = UISegmentedControl(items: ["System", "Dark", "Light"])
                
                if let tryData = defaults.object(forKey: "theme") as? Int {
                    segmentedControl.selectedSegmentIndex = tryData
                }else{
                    segmentedControl.selectedSegmentIndex = 0
                    defaults.set(0, forKey: "theme")
                }
                // Set the initial selected segment (if needed)
                
                segmentedControl.setWidth(100, forSegmentAt: 0)
                segmentedControl.setWidth(100, forSegmentAt: 1)
                segmentedControl.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60))

                // Customize the segmented control, if desired (e.g., font, color, etc.)
                // segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
                // segmentedControl.tintColor = .yourDesiredColor

                // Add a target to the segmented control to handle value changes
                segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

                // Add the segmented control to the stack view
                stackView.addArrangedSubview(segmentedControl)
            }
        }
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Set the background color based on the selected segment
        defaults.set(sender.selectedSegmentIndex, forKey: "theme")
        switch sender.selectedSegmentIndex {
        case 0:
            ColorTheme.label = UIColor.label
            ColorTheme.placeholderText = UIColor.placeholderText
            ColorTheme.highlight = UIColor.systemBlue
            ColorTheme.main = UIColor.systemBackground
            ColorTheme.secondary = UIColor.label
            ColorTheme.background = UIColor.systemBackground
        case 1:
            ColorTheme.label = UIColor.white
            ColorTheme.placeholderText = UIColor.darkGray
            ColorTheme.highlight = UIColor.systemBlue
            ColorTheme.main = UIColor.black
            ColorTheme.secondary = UIColor.white
            ColorTheme.background = UIColor.black
        case 2:
            ColorTheme.label = UIColor.black
            ColorTheme.placeholderText = UIColor.lightGray
            ColorTheme.highlight = UIColor.systemBlue
            ColorTheme.main = UIColor.white
            ColorTheme.secondary = UIColor.black
            ColorTheme.background = UIColor.white
        default:
            break
        }
    }
}
