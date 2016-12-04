//
//  HistoryCell.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 12/2/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

let kHistoryCell = "kHistoryCell"

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var production: Production!
    
    func load(production: Production){
        self.production = production
        self.productionLabel.text = "\(Int(production.production)) kW"
        self.totalLabel.text = "\(Int(production.total)) kW"
        self.dateLabel.text = production.date.toString()
    }
    
}
