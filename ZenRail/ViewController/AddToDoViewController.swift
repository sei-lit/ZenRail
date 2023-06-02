//
//  AddToDoViewController.swift
//  ZenRail
//
//  Created by 大森青 on 2023/05/25.
//

import UIKit

class AddToDoViewController: UIViewController {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var taskTextField: UITextField!
    
    var toDoDelegate: ToDoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 15
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 10), forImageIn: .normal)
        
    }
    
    func generateAlert(title: String, message: String, isDone: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if isDone{
                self.dismiss(animated: true, completion: nil)
            } else {
                print("OK")
            }
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedAddButton() {
        if taskTextField.text == "" {
            generateAlert(title: "エラー", message: "入力してください", isDone: false)
        } else {
            toDoDelegate?.addNewToDo(taskName: taskTextField.text!)
            generateAlert(title: "完了", message: "タスクの追加が完了しました", isDone: true)
        }
    }
    
    @IBAction func tappedBackButton() {
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
