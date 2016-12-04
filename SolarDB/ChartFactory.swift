//
//  ChartFactory.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/19/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import Charts

class AxisFormater: NSObject, IAxisValueFormatter {
    
    var formater: ((Double) -> String)!
    
    init(formater: @escaping ((Double) -> String)) {
        super.init()
        self.formater = formater
    }
    
    public func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String{
        return self.formater(value)
    }
    
}

class ChartFactory: AnyObject{
    
    static func generateLineChart<T>(series: [[T?]], names: [String], criteria: ((T) -> Double), yFormater: @escaping ((Double) -> String)) -> LineChartView{
        let chartView = LineChartView(frame: CGRect.zero)
        chartView.noDataText = "Aucune données disponible."
        
        if series[0].count == 0 && series[1].count == 0 {
            return chartView
        }
        
        var chartDataSets:[ChartDataSet] = []
        var numberSerie = 0
        
        for serie in series {
            var dataEntries: [ChartDataEntry] = []
            var i = 0
            for data in serie {
                if data != nil {
                    let entry = ChartDataEntry(x: Double(i), y: criteria(data!))
                    dataEntries.append(entry)
                }
                i+=1
            }
            let chartDataSet = LineChartDataSet(values: dataEntries, label: names[numberSerie])
            chartDataSet.mode = .horizontalBezier
            chartDataSet.drawFilledEnabled = false
            chartDataSet.circleRadius = 2
            chartDataSet.drawCirclesEnabled = true
            chartDataSet.drawValuesEnabled = false
            if numberSerie == 0 {
                chartDataSet.colors = [UIColor(netHex: 0x2196F3)]
                chartDataSet.circleColors = [UIColor(netHex: 0x2196F3)]
                
            }else{
                chartDataSet.colors = [UIColor(netHex: 0x0D47A1)]
                chartDataSet.circleColors = [UIColor(netHex: 0x0D47A1)]
            }
            chartDataSets.append(chartDataSet)
            numberSerie += 1
        }
        
        let chartData = LineChartData(dataSets: chartDataSets)
        
        chartView.xAxis.valueFormatter = AxisFormater(formater: { value in
            return String(format: "%02d",Int(value+1))
        });
        
        chartView.leftAxis.valueFormatter = AxisFormater(formater: yFormater)
        
        chartView.data = chartData
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelRotationAngle = -45
        chartView.chartDescription = nil
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        
        chartView.rightAxis.enabled = false
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        
        chartView.legend.horizontalAlignment = .center
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .horizontal
        chartView.legend.drawInside = false
        chartView.legend.direction = .leftToRight
        chartView.legend.enabled = true
        
        let numberOfData1 = series.first!.filter({ (element) -> Bool in
            return element != nil
        }).count
        let numberOfData2 = series.last!.filter({ (element) -> Bool in
            return element != nil
        }).count
        let numberOfData = max(numberOfData1, numberOfData2)
        chartView.xAxis.labelCount = (numberOfData > 15 ? numberOfData/2 : numberOfData-1)
        

        return chartView
    }
    
    static func generateBarChart(series: [[Double:Double]], names: [String], xFormater: @escaping ((Double) -> String)) -> BarChartView{
        let chartView = BarChartView(frame: CGRect.zero)
        
        chartView.noDataText = "Aucune données disponible."
        var chartDataSets:[ChartDataSet] = []
        var numberSerie = 0
        
        for serie in series {
            var dataEntries: [BarChartDataEntry] = []
            for (key, value) in serie {
                let entry = BarChartDataEntry(x: key, y: value)
                dataEntries.append(entry)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: names[numberSerie])
            chartDataSet.drawValuesEnabled = false
            if numberSerie == 0 {
                chartDataSet.colors = [UIColor(netHex: 0x2196F3)]
                chartDataSet.barBorderColor = .white
            }else{
                chartDataSet.colors = [UIColor(netHex: 0x0D47A1)]
            }
            
            chartDataSets.append(chartDataSet)
            
            numberSerie += 1
        }
        
        let chartData = BarChartData(dataSets: chartDataSets)
        
        chartView.xAxis.valueFormatter = AxisFormater(formater: xFormater)
        
        chartView.leftAxis.valueFormatter = AxisFormater(formater: { value in
            return "\(Int(value))kW"
        });
        
        chartView.data = chartData
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelRotationAngle = -45
        
        chartView.chartDescription = nil
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        
        chartView.rightAxis.enabled = false
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        
        chartView.legend.horizontalAlignment = .center
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .horizontal
        chartView.legend.drawInside = false
        chartView.legend.direction = .leftToRight
        chartView.legend.enabled = true
        
        chartView.xAxis.labelCount = series.first!.count //(numberOfData > 15 ? numberOfData/2 : numberOfData-1)
        
        return chartView
    }

}
