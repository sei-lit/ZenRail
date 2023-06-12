//
//  ToDoViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/24.
//

import UIKit

class ToDoViewController: UIViewController {

    @IBOutlet var toDoTableView: UITableView!
    
    var tasks: [[String]] = [
        [],
        []
    ]
    
    var toDoDelegate: ToDoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        toDoTableView.dataSource = self
        toDoTableView.delegate = self
        toDoTableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "toDoCell")
        
        createTabBar(x: CGFloat(view.frame.width / 2), y: CGFloat(view.frame.height / 10 * 9), width: 320, height: 50)
    }
    
    func createTabBar(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let rect = CGRect(x: x - (width / 2), y: y, width: width, height: height)
        let customTabBar = UIView(frame: rect)
        
        let homeIconImage: UIImage = UIImage(systemName: "house")!
        let toDoIconImage: UIImage = UIImage(systemName: "list.bullet")!
        
        let homeButton = UIButton(frame: CGRect(x: CGFloat((customTabBar.frame.width / 2) - 50), y: y + 7.5, width: 35, height: 35))
        let toDoButton = UIButton(frame: CGRect(x: CGFloat((customTabBar.frame.width / 2) + 85), y: y + 7.5, width: 35, height: 35))
        
        homeButton.setImage(homeIconImage, for: .normal)
        toDoButton.setImage(toDoIconImage, for: .normal)
        homeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        toDoButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        
        homeButton.contentMode = .scaleAspectFit
        toDoButton.contentMode = .scaleAspectFit
        
        homeButton.tintColor = UIColor.white
        toDoButton.tintColor = UIColor(hex: "EAE75B")
        
        customTabBar.layer.masksToBounds = false
        customTabBar.backgroundColor = UIColor(hex: "3C6255")
        customTabBar.layer.shadowColor = UIColor(hex: "3C6255", alpha: 0.5).cgColor
        customTabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        customTabBar.layer.shadowRadius = 15
        customTabBar.layer.shadowOpacity = 1
        
        customTabBar.clipsToBounds = false
        customTabBar.layer.cornerRadius = 12
        
        homeButton.addTarget(self, action: #selector(tappedHomeButton), for: .touchUpInside)
        
        view.addSubview(customTabBar)
        view.addSubview(homeButton)
        view.addSubview(toDoButton)
    }
    
    @objc func tappedHomeButton() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! ViewController
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func tappedToAddButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let AddToDoViewController = storyboard.instantiateViewController(identifier: "AddToDoViewController") as! AddToDoViewController
        AddToDoViewController.modalPresentationStyle = .formSheet
        AddToDoViewController.toDoDelegate = self
        present(AddToDoViewController, animated: true, completion: nil)
    }

}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDoTableViewCell
        
        toDoDelegate = cell
        cell.toDoDelegate = self
        cell.taskLabel.text = tasks[indexPath.section][indexPath.row]
        
        if indexPath.section == 1 {
            toDoDelegate?.getIsDone(isDone: true)
        } else {
            toDoDelegate?.getIsDone(isDone: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "取組中"
        } else {
            return "完了"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                tasks[0].remove(at: indexPath.row)
            } else {
                tasks[1].remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ToDoViewController: ToDoDelegate {
    func addNewToDo(taskName: String) {
        tasks[0].append(taskName)
        toDoTableView.reloadData()
    }
    
    func getIsDone(isDone: Bool) {
        return
    }
    
    func switchSection(task: String, isDone: Bool) {
        if isDone {
            tasks[1].removeAll(where: {$0 == task})
            tasks[0].append(task)
            toDoTableView.reloadData()
        } else {
            tasks[0].removeAll(where: {$0 == task})
            tasks[1].append(task)
            toDoTableView.reloadData()
        }
    }
}
