//
//  ChartView.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/19/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartView: UIView{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    var chart: UIView!
    
    func load(title:String, subtitle:String, chart: UIView){
        self.chart = chart
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func fromNib() -> ChartView {
        return Bundle.main.loadNibNamed("ChartView", owner: self, options: nil)?[0] as! ChartView
    }
    
    func generateChart(){
        let frame = self.chartView.bounds
        self.chart.frame = frame
        self.chart.updateConstraints()
        self.chartView.addSubview(self.chart)
    }
   
}
