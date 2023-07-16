//
//  FlowchartVC.swift
//  To Do
//
//  Created by Matthew Lundeen on 6/12/23.
//

import UIKit

class FlowchartVC: UIViewController {
    
    // Create an array to store the rectangles
    var rectangles: [UIView] = []
    let viewHolder: UIView = UIView(frame: CGRect())

    // Store the initial touch point
    var initialTouchPoint: CGPoint = CGPoint.zero
    
    let defaults = UserDefaults.standard
    static var taskGroups: [TaskGroup] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        if let tryData = defaults.object(forKey: "taskGroups") as? [TaskGroup] {
            FlowchartVC.taskGroups = tryData;
        }else{
            defaults.set(FlowchartVC.taskGroups, forKey: "taskGroups")
        }
        
        let group1 = TaskGroup(ID: 0, senderTasks: [], nextTasks: [1], tasks: ["Group 1 task 1", "Group 1 task 2"])
        let group2 = TaskGroup(ID: 1, senderTasks: [0], nextTasks: [2], tasks: ["Group 2 task 1", "Group 2 task 2"])
        let group3 = TaskGroup(ID: 2, senderTasks: [1], nextTasks: [3], tasks: ["Group 3 task 1", "Group 3 task 2"])
        let group4 = TaskGroup(ID: 3, senderTasks: [2], nextTasks: [], tasks: ["Group 4 task 1", "Group 4 task 2"])
        FlowchartVC.taskGroups = [group1, group2, group3, group4]
        generateGroups()

        // Enable user interaction and add a gesture recognizer to the view
        view.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }

    // Method to add rectangles to the view
//    func generateGroups() {
//        // Create rectangles with different colors and sizes
//        let center = view.center
//
//        for i in 0..<FlowchartVC.taskGroups.count {
//            let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            rectangle.backgroundColor = UIColor.white
//            rectangle.layer.cornerRadius = 10
//            rectangle.center = CGPoint(x: center.x + CGFloat(i * 150), y: center.y)
//            view.addSubview(rectangle)
//            rectangles.append(rectangle)
//        }
//    }
    func generateGroups() {
        // Create a stack view
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 10 // Adjust spacing as needed
            
            // Add a background view to the stack view
            let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.secondarySystemBackground
        backgroundView.layer.cornerRadius = 16
            stackView.addSubview(backgroundView)
        
        let groupTitleLabel = UILabel()
            groupTitleLabel.text = "Group Title"
            groupTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold) // Adjust the font size and weight as desired
        groupTitleLabel.textColor = UIColor.secondaryLabel
            groupTitleLabel.textAlignment = .left
            groupTitleLabel.numberOfLines = 0 // Allow multiple lines if needed
            groupTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the settings image view
            let settingsImageView = UIImageView(image: UIImage(systemName: "gearshape.fill")) // Replace "settings" with the actual name of your image
            settingsImageView.contentMode = .scaleAspectFit
            settingsImageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Create a container view for the group title and settings image
            let groupTitleContainerView = UIView()
            groupTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the group title label and settings image view to the container view
            groupTitleContainerView.addSubview(groupTitleLabel)
            groupTitleContainerView.addSubview(settingsImageView)
        
        // Configure auto layout constraints for the group title container view
            NSLayoutConstraint.activate([
                groupTitleLabel.leadingAnchor.constraint(equalTo: groupTitleContainerView.leadingAnchor),
                groupTitleLabel.topAnchor.constraint(equalTo: groupTitleContainerView.topAnchor),
                groupTitleLabel.bottomAnchor.constraint(equalTo: groupTitleContainerView.bottomAnchor),
                
                settingsImageView.leadingAnchor.constraint(equalTo: groupTitleLabel.trailingAnchor, constant: 8),
                settingsImageView.trailingAnchor.constraint(equalTo: groupTitleContainerView.trailingAnchor),
                settingsImageView.centerYAnchor.constraint(equalTo: groupTitleLabel.centerYAnchor),
                settingsImageView.widthAnchor.constraint(equalToConstant: 20), // Adjust the width as desired
                settingsImageView.heightAnchor.constraint(equalToConstant: 20) // Adjust the height as desired
            ])
            
            // Add the group title container view above the stack view
            stackView.addSubview(groupTitleContainerView)
            // Create a constant width for the stack view
            let stackViewWidth: CGFloat = 280 // Adjust the width as needed
            
            // Add labels to the stack view
            let labels = [
                "First label",
                "Second label with a longer text that will span multiple lines. This is an example of a long text that will wrap to multiple lines when it exceeds the available width of the label.",
                "Third label",
                "Fourth label",
                "Maybe like around two lines for label number five",
                "six"
            ]
            
            for labelText in labels {
                // Create a container view for each label
                let containerView = UIView()
                containerView.translatesAutoresizingMaskIntoConstraints = false
                
                // Create a small circle view
                let circleView = UIView()
                circleView.backgroundColor = .clear
                circleView.layer.borderColor = UIColor.label.cgColor
                circleView.layer.borderWidth = 2
                circleView.translatesAutoresizingMaskIntoConstraints = false
                circleView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                circleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
                circleView.layer.cornerRadius = 10 // Adjust the radius to control the circle size
                
                containerView.addSubview(circleView)
                
                // Create the label
                let label = UILabel()
                label.text = labelText
                label.textColor = UIColor.label
                label.numberOfLines = 0 // Allow multiple lines if needed
                label.translatesAutoresizingMaskIntoConstraints = false
                
                containerView.addSubview(label)
                
                // Configure auto layout constraints for the container view
                NSLayoutConstraint.activate([
                    circleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
                    circleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                    
                    label.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8),
                    label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                    label.topAnchor.constraint(equalTo: containerView.topAnchor),
                    label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
                
                stackView.addArrangedSubview(containerView)
            }
            
            // Configure auto layout constraints for the stack view
            stackView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // Stack view constraints
                stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
                stackView.widthAnchor.constraint(equalToConstant: stackViewWidth),
                
                // Background view constraints
                backgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
                backgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
                backgroundView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -8),
                backgroundView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
                
                // Group title label constraints
                groupTitleContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
                        groupTitleContainerView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -40),
                        groupTitleContainerView.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor, constant: -16)
            ])
        viewHolder.addSubview(stackView)
        view.addSubview(viewHolder)
        viewHolder.layer.position = view.center
        stackView.center = viewHolder.convert(viewHolder.center, from:viewHolder.superview)
    }






    // Method to handle the pan gesture
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.view)

        switch gestureRecognizer.state {
        case .began:
            // Store the initial touch point
            initialTouchPoint = touchPoint

        case .changed:
            // Calculate the translation distance
            let translation = CGPoint(x: touchPoint.x - initialTouchPoint.x, y: touchPoint.y - initialTouchPoint.y)

            // Pan/Scroll the rectangles accordingly
//            for rectangle in rectangles {
//                var center = rectangle.center
//                center.x += translation.x
//                center.y += translation.y
//                rectangle.center = center
//            }
            var center = viewHolder.center
            center.x += translation.x
            center.y += translation.y
            viewHolder.center = center
            // Reset the initial touch point
            initialTouchPoint = touchPoint

        default:
            break
        }
    }
}
		
