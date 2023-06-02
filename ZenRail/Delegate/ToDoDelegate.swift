//
//  ToDoDelegate.swift
//  ZenRail
//
//  Created by 大森青 on 2023/06/01.
//

import Foundation

protocol ToDoDelegate: AnyObject {
    func getIsDone(isDone: Bool)
    func switchSection(task: String, isDone:Bool)
    func addNewToDo(taskName: String)
}
