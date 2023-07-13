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

        // Store the initial touch point
        var initialTouchPoint: CGPoint = CGPoint.zero

        override func viewDidLoad() {
            super.viewDidLoad()
    // Add rectangles to the view
    addRectangles()

    // Enable user interaction and add a gesture recognizer to the view
    view.isUserInteractionEnabled = true
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    view.addGestureRecognizer(panGesture)
}

// Method to add rectangles to the view
func addRectangles() {
    // Create rectangles with different colors and sizes
    let center = view.center

    for i in 0..<4 {
        let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        rectangle.backgroundColor = UIColor.white
        rectangle.layer.cornerRadius = 10
        rectangle.center = CGPoint(x: center.x + CGFloat(i * 150), y: center.y)
        view.addSubview(rectangle)
        rectangles.append(rectangle)
    }
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
        for rectangle in rectangles {
            var center = rectangle.center
            center.x += translation.x
            center.y += translation.y
            rectangle.center = center
        }

        // Reset the initial touch point
        initialTouchPoint = touchPoint

    default:
        break
    }
}
}
		
