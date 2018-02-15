//
//  AddEmployeeViewController.swift
//  shop-keep
//
//  Created by Kaichi Momose on 2018/02/14.
//  Copyright © 2018 Eliel Gordon. All rights reserved.
//

import UIKit

enum Position {
    case employee
    case manager
}

class AddEmployeeViewController: UIViewController {
    
    let coreDataStack = CoreDataStack.instance
    
    var position: Position = .employee
    
    var shop: Shop?
    var managers = [Employee]()
    var employees = [Employee]()
    var manager: Employee?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var managerSC: UISegmentedControl!
    @IBOutlet weak var managerLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var managerSelection: UIStackView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self

//        saveButton.isHidden = true
        managerSC.addTarget(self, action: #selector(segmentSlected), for: .valueChanged)
        managerLabel.isHidden = true
        toolbar.isHidden = true
        pickerView.isHidden = true
        
        guard let employees = shop?.employees?.allObjects as? [Employee] else {return}
        for employee in employees {
            if employee.isManager {
                managers.append(employee)
            } else {
                self.employees.append(employee)
            }
        }
    }

    @objc func segmentSlected() {
        switch managerSC.selectedSegmentIndex {
        case 1:
            position = .manager
            managerLabel.text =  ""
            managerSelection.isHidden = true
        default:
            position = .employee
            managerSelection.isHidden = false
        }
    }
    
    @IBAction func selectTapped(_ sender: Any) {
        
        toolbar.isHidden = false
        pickerView.isHidden = false
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let saveContext = coreDataStack.privateContext
        if let shop = self.shop, let name = nameTextField.text, !name.isEmptyOrWhitespace {
            let newEmployee = Employee(
                context: saveContext
            )
            newEmployee.name = name
            switch position {
                case .employee:
                    guard let manager = self.manager else {return}
                    let privateManager = saveContext.object(with: manager.objectID) as! Employee
                    newEmployee.manager = privateManager
                case .manager:
                    newEmployee.isManager = true
            }
            let privateShop = saveContext.object(with: shop.objectID) as! Shop
            newEmployee.shop = privateShop
            coreDataStack.saveTo(context: saveContext)
//            coreDataStack.viewContext.refresh(newEmployee, mergeChanges: true)
        } else {
            return
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if let manager = manager {
            managerLabel.text = manager.name
            managerLabel.isHidden = false
        }
        toolbar.isHidden = true
        pickerView.isHidden = true
    }
    
}

extension AddEmployeeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return managers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return managers[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        manager = managers[row]
    }
}
