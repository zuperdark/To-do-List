//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by Alex  on 8/11/23.
//

import UIKit

protocol AddItemTableViewControllerDelegate: AnyObject {
    func addItemTableViewControllerDidCancel(
        _ controller: AddItemTableViewController)
    func addItemTableViewController(
        _ controller: AddItemTableViewController,
        didFinishAdding item: ChecklistItem
    )
    func addItemTableViewController(
        _ controller: AddItemTableViewController,
        didFinishEditing item: ChecklistItem
    )
}

class AddItemTableViewController: UITableViewController,
                                  UITextFieldDelegate{
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: AddItemTableViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
          }
    }
    //MARK: - Action
    @IBAction func cancel() {
        delegate?.addItemTableViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.addItemTableViewController(self,didFinishEditing: item)
          } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.addItemTableViewController(self, didFinishAdding: item)
        }
    }

    //MARK: - Table View Delegates
    override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
   
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        if newText.isEmpty{
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}

