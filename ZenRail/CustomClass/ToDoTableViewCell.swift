//
//  ToDoTableViewCell.swift
//  ZenRail
//
//  Created by 大森青 on 2023/06/01.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    var isDone: Bool = false
    var toDoDelegate: ToDoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func tappedDoneButton() {
        if !isDone {
            doneButton.backgroundColor = UIColor(hex: "3C6255")
            isDone = true
            toDoDelegate?.switchSection(task: taskLabel.text ?? "", isDone: false)
        } else {
            doneButton.backgroundColor = UIColor.clear
            isDone = false
            toDoDelegate?.switchSection(task: taskLabel.text ?? "", isDone: true)
        }
    }
}

extension ToDoTableViewCell: ToDoDelegate {
    func addNewToDo(taskName: String) {
        return
    }
    
    func switchSection(task: String, isDone: Bool) {
        return
    }
    
    func getIsDone(isDone: Bool) {
        if isDone {
            doneButton.backgroundColor = UIColor(hex: "3C6255")
            self.isDone = isDone
        } else {
            doneButton.backgroundColor = UIColor.clear
            self.isDone = isDone
        }
    }
    
}
