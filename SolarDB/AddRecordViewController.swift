//
//  AddRecordViewController.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 12/2/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

class AddRecordViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var productionTextField: UITextField!
    @IBOutlet weak var totalTextField: UITextField!
    
    var date = Date()
    var production: Production?
    
    override func viewDidLoad() {
        self.productionTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dateLabel.text = self.date.toString()
        if let prod = self.production {
            self.dateLabel.text = "\(prod.date.toString())"
            self.productionTextField.text = "\(Int(prod.production))"
            self.totalTextField.text = "\(Int(prod.total))"
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.productionTextField.resignFirstResponder()
        self.totalTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let prod = productionTextField.text, prod.characters.count > 0 else { return }
        guard let total = totalTextField.text, total.characters.count > 0 else { return }
        self.productionTextField.resignFirstResponder()
        self.totalTextField.resignFirstResponder()
        
        let production = Production(date: self.date, production: Double(prod)!, total: Double(total)!)
        RequestManager.record(production: production)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
