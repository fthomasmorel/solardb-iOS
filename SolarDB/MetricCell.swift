//
//  MetricCell.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/19/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

let kMetricCell = "kMetricCell"

class MetricCell: UITableViewCell{
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var metricLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func layoutSubviews() {
        self.frontView.layer.shadowColor = UIColor.black.cgColor
        self.frontView.layer.shadowOpacity = 0.2
        self.frontView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.frontView.layer.shadowRadius = 2
    }

    func load(title: String, unit: String, current: Double?, previous: Double?, scaleTime: TimeScale){
        self.titleLabel.text = title
        self.dateLabel.text = ""
        self.metricLabel.text = "- \(unit)"
        self.progressLabel.text = "+-0.00%"
        if let value1 = current {
            var scale = ""
            switch scaleTime {
            case .day:
                scale = "Au jour"
            case .month:
                scale = "Au mois"
            case .year:
                scale = "A l'année"
            }
            self.dateLabel.text = scale
            if unit == "€" {
                self.metricLabel.text = "\(String(format: "%.2f", value1))\(unit)"
            }else{
                self.metricLabel.text = "\(Int(value1))\(unit)"
            }
            
            if let value2 = previous {
                let progress = ((value1 - value2)/value1)*100
                if progress >= 0 {
                    self.progressLabel.textColor = UIColor(netHex: 0x70BF41)
                    self.progressLabel.text = "+\(String(format: "%.2f", progress))%"
                }else{
                    self.progressLabel.textColor = UIColor(netHex: 0xEC5D57)
                    self.progressLabel.text = "\(String(format: "%.2f", progress))%"
                }
            }
        }
    }
    
}
