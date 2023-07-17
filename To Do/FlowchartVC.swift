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
        
        let group1 = TaskGroup(ID: 0, title: "Group 1", senderTasks: [], nextTasks: [2], tasks: ["Group 1 task 1", "Group 1 task 2", "Group 1 task 3"])
        let group2 = TaskGroup(ID: 1, title: "Group 2", senderTasks: [], nextTasks: [3], tasks: ["Group 2 task 1", "Group 2 task 2"])
        let group3 = TaskGroup(ID: 2, title: "Group 3", senderTasks: [1], nextTasks: [], tasks: ["Group 3 task 1", "Group 3 task 2"])
        let group4 = TaskGroup(ID: 3, title: "Group 4", senderTasks: [2], nextTasks: [], tasks: ["Group 4 task 1", "Group 4 task 2"])
        FlowchartVC.taskGroups = [group1, group2, group3, group4]
        
        var c: [Int] = []
        for (i, group) in FlowchartVC.taskGroups.enumerated() {
            if(group.senderTasks == []){
                c.append(i)
            }
        }
        for i in 0 ..< c.count {
            let stackView = generateGroup(taskGroup: FlowchartVC.taskGroups[c[i]])
            viewHolder.addSubview(stackView)
            stackView.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: 100).isActive = true //+350
            stackView.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: CGFloat(300 * (i + 1))).isActive = true
            generateNextGroup(lastX: 100, lastY: 300 * (i + 1), lastGroup: FlowchartVC.taskGroups[c[i]])
        }
        
        
        view.addSubview(viewHolder)
        
        
        // Enable user interaction and add a gesture recognizer to the view
        view.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func generateNextGroup(lastX: Int, lastY: Int, lastGroup: TaskGroup) {
        var nextGroups: [TaskGroup] = []
        for i in lastGroup.nextTasks {
            for g in FlowchartVC.taskGroups {
                if(i == g.ID){
                    nextGroups.append(g)
                }
            }
        }
        for (i, group) in nextGroups.enumerated() {
            let stackView = generateGroup(taskGroup: group)
            viewHolder.addSubview(stackView)
            stackView.leadingAnchor.constraint(equalTo: viewHolder.leadingAnchor, constant: CGFloat(lastX + 200)).isActive = true //+350
            let newYPos = lastY + Int(300 * ((Double(i) / Double(nextGroups.count - 1)) - 0.5))
            stackView.topAnchor.constraint(equalTo: viewHolder.topAnchor, constant: CGFloat(newYPos)).isActive = true
            generateNextGroup(lastX: 100, lastY: newYPos, lastGroup: group)
        }
    }
    
    func generateGroup(taskGroup: TaskGroup) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.secondarySystemBackground
        backgroundView.layer.cornerRadius = 16
        stackView.addSubview(backgroundView)
    
        let groupTitleLabel = UILabel()
        groupTitleLabel.text = taskGroup.title
        groupTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        groupTitleLabel.textColor = UIColor.secondaryLabel
        groupTitleLabel.textAlignment = .left
        groupTitleLabel.numberOfLines = 0
        groupTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let settingsImageView = UIImageView(image: UIImage(systemName: "gearshape.fill"))
        settingsImageView.contentMode = .scaleAspectFit
        settingsImageView.translatesAutoresizingMaskIntoConstraints = false
        settingsImageView.tintColor = UIColor.secondaryLabel
        
        let groupTitleContainerView = UIView()
        groupTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        groupTitleContainerView.addSubview(groupTitleLabel)
        groupTitleContainerView.addSubview(settingsImageView)
        
        
        stackView.addSubview(groupTitleContainerView)
        let stackViewWidth: CGFloat = 280
        
        for labelText in taskGroup.tasks {
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
            groupTitleContainerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            groupTitleContainerView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -40),
            groupTitleContainerView.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor),
            
            groupTitleLabel.leadingAnchor.constraint(equalTo: groupTitleContainerView.leadingAnchor),
            groupTitleLabel.topAnchor.constraint(equalTo: groupTitleContainerView.topAnchor),
            groupTitleLabel.bottomAnchor.constraint(equalTo: groupTitleContainerView.bottomAnchor),
           
            settingsImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            settingsImageView.centerYAnchor.constraint(equalTo: groupTitleLabel.centerYAnchor),
            settingsImageView.widthAnchor.constraint(equalToConstant: 20),
            settingsImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return stackView
    }

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
		
