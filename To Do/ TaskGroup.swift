//
//   TaskGroup.swift
//  To Do
//
//  Created by Matthew Lundeen on 7/13/23.
//

import Foundation

class TaskGroup {
    let defaults = UserDefaults.standard
    let ID: Int
    let title: String
    let senderTasks: [Int]
    let nextTasks: [Int]
    let tasks: [String]
    
    init(ID: Int, title: String, senderTasks: [Int], nextTasks: [Int], tasks: [String]) {
        self.ID = ID
        self.title = title
        self.senderTasks = senderTasks
        self.nextTasks = nextTasks
        self.tasks = tasks
    }
}
