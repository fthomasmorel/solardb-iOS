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
    
    var date = Date()
    var production: Production?
    
    override func viewDidLoad() {
        self.productionTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dateLabel.text = self.date.toString()
        if let prod = self.production {
            self.dateLabel.text = "\(prod.date.toString())"
            self.productionTextField.text = "\(Int(prod.total))"
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.productionTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let total = productionTextField.text, total.characters.count > 0 else { return }
        self.productionTextField.resignFirstResponder()
        
        if let previousProduction = self.production {
            let prod = Double(total)!-previousProduction.total
            let production = Production(date: self.date, production: prod, total: Double(total)!)
            RequestManager.record(production: production)
        }else{
            let production = Production(date: self.date, production: Double(total)!, total: Double(total)!)
            RequestManager.record(production: production)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
