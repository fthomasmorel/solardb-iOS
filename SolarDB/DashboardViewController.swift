//
//  ViewController.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/18/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CalendarDelegate {

    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var topDateLabel: UILabel!
    @IBOutlet weak var compareDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIVisualEffectView!
    
    var currentDate = Date()
    var currentTimeScale: TimeScale = .day
    
    var production:                     Production? = nil
    var currentProduction :             Double? = nil
    var previousProduction :            Double? = nil
    
    var monthlyWeather :                [Weather?] = []
    var yearlyWeather :                 [Weather?] = []
    var previousMonthlyWeather :        [Weather?] = []
    var previousYearlyWeather :         [Weather?] = []
    var allProduction :                 [[Production]] = []
    var monthlyProduction :             [Production?] = []
    var yearlyProduction :              [Production?] = []
    var previousMonthlyProduction :     [Production?] = []
    var previousYearlyProduction :      [Production?] = []
    
    var cacheManager = CacheManager()
    var downloadGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UINib(nibName: "MetricCell", bundle: nil), forCellReuseIdentifier: kMetricCell)
        self.tableView.register(UINib(nibName: "ChartsCell", bundle: nil), forCellReuseIdentifier: kChartsCell)
        
        self.updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarView.layer.shadowColor = UIColor.black.cgColor
        self.tabBarView.layer.shadowOpacity = 0.2
        self.tabBarView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.tabBarView.layer.shadowRadius = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kMetricCell, for: indexPath) as! MetricCell
            cell.load(title: "Production", unit: "kW", current: self.currentProduction, previous: self.previousProduction, scaleTime: self.currentTimeScale)
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kMetricCell, for: indexPath) as! MetricCell
            let price = 0.60039
            var currentValue: Double? = nil
            if let value = self.currentProduction{
                currentValue = value * price
            }
            var previousValue: Double? = nil
            if let value = self.previousProduction{
                previousValue = value * price
            }
            cell.load(title: "Revenu", unit: "€", current: currentValue , previous: previousValue, scaleTime: self.currentTimeScale)
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kChartsCell, for: indexPath) as! ChartsCell
            let chart1 = ChartFactory.generateLineChart(series: [self.monthlyProduction, self.previousMonthlyProduction], names: [self.currentDate.monthName(), self.currentDate.previousMonth().monthName()], criteria: { production in production.production}, yFormater: { value in return "\(Int(value))kW" })
            let chart2 = ChartFactory.generateLineChart(series: [yearlyProduction, previousYearlyProduction], names: [self.currentDate.year(), self.currentDate.previousYear().year()], criteria: { production in production.production}, yFormater: { value in return "\(Int(value))kW" })
            var views:[ChartView] = []
            if self.currentTimeScale != .year {
                let view1 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
                view1.load(title: "Production", subtitle: "Au mois", chart: chart1)
                views.append(view1)
            }
            let view2 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view2.load(title: "Production", subtitle: "À l'année", chart: chart2)
            views.append(view2)
            cell.loadViews(views: views)
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kChartsCell, for: indexPath) as! ChartsCell
            let chart1 = ChartFactory.generateLineChart(series: [self.monthlyWeather, self.previousMonthlyWeather], names: [self.currentDate.monthName(), self.currentDate.previousMonth().monthName()], criteria: { weather in weather.temperature}, yFormater: { value in return "\(Int(value))ºC" })
            let chart2 = ChartFactory.generateLineChart(series: [yearlyWeather, previousYearlyWeather], names: [self.currentDate.year(), self.currentDate.previousYear().year()], criteria: { weather in weather.temperature}, yFormater: { value in return "\(Int(value))ºC" })
            var views:[ChartView] = []
            if self.currentTimeScale != .year {
                let view1 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
                view1.load(title: "Température", subtitle: "Au mois", chart: chart1)
                views.append(view1)
            }
            let view2 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view2.load(title: "Température", subtitle: "À l'année", chart: chart2)
            views.append(view2)
            cell.loadViews(views: views)
            return cell
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kChartsCell, for: indexPath) as! ChartsCell
            let chart1 = ChartFactory.generateLineChart(series: [self.monthlyWeather, self.previousMonthlyWeather], names: [self.currentDate.monthName(), self.currentDate.previousMonth().monthName()], criteria: { weather in weather.sunshine}, yFormater: { value in return "\(Int(value))h" })
            let chart2 = ChartFactory.generateLineChart(series: [yearlyWeather, previousYearlyWeather], names: [self.currentDate.year(), self.currentDate.previousYear().year()], criteria: { weather in weather.sunshine}, yFormater: { value in return "\(Int(value))h" })
            var views:[ChartView] = []
            if self.currentTimeScale != .year {
                let view1 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
                view1.load(title: "Ensoleillement", subtitle: "Au mois", chart: chart1)
                views.append(view1)
            }
            let view2 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view2.load(title: "Ensoleillement", subtitle: "À l'année", chart: chart2)
            views.append(view2)
            cell.loadViews(views: views)
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kChartsCell, for: indexPath) as! ChartsCell
            let chart1 = ChartFactory.generateLineChart(series: [self.monthlyWeather, self.previousMonthlyWeather], names: [self.currentDate.monthName(), self.currentDate.previousMonth().monthName()], criteria: { weather in weather.cloudCover*100 }, yFormater: { value in return "\(Int(value))%" })
            let chart2 = ChartFactory.generateLineChart(series: [yearlyWeather, previousYearlyWeather], names: [self.currentDate.year(), self.currentDate.previousYear().year()], criteria: { weather in weather.cloudCover*100}, yFormater: { value in return "\(Int(value))%" })
            var views:[ChartView] = []
            if self.currentTimeScale != .year {
                let view1 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
                view1.load(title: "Couverture Nuageuse", subtitle: "Au mois", chart: chart1)
                views.append(view1)
            }
            let view2 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view2.load(title: "Couverture Nuageuse", subtitle: "À l'année", chart: chart2)
            views.append(view2)
            cell.loadViews(views: views)
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kChartsCell, for: indexPath) as! ChartsCell
            let chart1 = ChartFactory.generateLineChart(series: [self.monthlyWeather, self.previousMonthlyWeather], names: [self.currentDate.monthName(), self.currentDate.previousMonth().monthName()], criteria: { weather in weather.humidity*100}, yFormater: { value in return "\(Int(value))%" })
            let chart2 = ChartFactory.generateLineChart(series: [yearlyWeather, previousYearlyWeather], names: [self.currentDate.year(), self.currentDate.previousYear().year()], criteria: { weather in weather.humidity*100 }, yFormater: { value in return "\(Int(value))%" })
            var views:[ChartView] = []
            if self.currentTimeScale != .year {
                let view1 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
                view1.load(title: "Humidité", subtitle: "Au mois", chart: chart1)
                views.append(view1)
            }
            let view2 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view2.load(title: "Humidité", subtitle: "À l'année", chart: chart2)
            views.append(view2)
            cell.loadViews(views: views)
            return cell

        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: kChartsCell, for: indexPath) as! ChartsCell
            let weathers = self.yearlyWeather.filter({ (weather) -> Bool in
                return weather != nil
            })
            
            let productions = self.yearlyProduction.filter({ (production) -> Bool in
                return production != nil
            })
            
            let temperature = Production.generateProductionFunctionOfCriteria(crtieria: { (weather) -> Double in
                Double(Int(weather.temperature))
            }, weathers: weathers as! [Weather], productions: productions as! [Production])
            
            let sunshine = Production.generateProductionFunctionOfCriteria(crtieria: { (weather) -> Double in
                Double(Int(weather.sunshine))
            }, weathers: weathers as! [Weather], productions: productions as! [Production])
            
            let cloudCover = Production.generateProductionFunctionOfCriteria(crtieria: { (weather) -> Double in
                Double(Int(weather.cloudCover*100))
            }, weathers: weathers as! [Weather], productions: productions as! [Production])
            
            let humidity = Production.generateProductionFunctionOfCriteria(crtieria: { (weather) -> Double in
                Double(Int(weather.humidity*100))
            }, weathers: weathers as! [Weather], productions: productions as! [Production])
            
            let chart1 = ChartFactory.generateBarChart(series: [temperature], names: [self.currentDate.year()], xFormater: { value in return "\(Int(value))ºC" })
            let chart2 = ChartFactory.generateBarChart(series: [sunshine], names: [self.currentDate.year()], xFormater: { value in return "\(Int(value))h" })
            let chart3 = ChartFactory.generateBarChart(series: [cloudCover], names: [self.currentDate.year()], xFormater: { value in return "\(Int(value))%" })
            let chart4 = ChartFactory.generateBarChart(series: [humidity], names: [self.currentDate.year()], xFormater: { value in return "\(Int(value))%" })

            let view1 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view1.load(title: "Prod. x Temp.", subtitle: "Cette année", chart: chart1)
            
            let view2 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view2.load(title: "Prod. x Ensolleillement", subtitle: "Cette année", chart: chart2)
            
            let view3 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view3.load(title: "Prod. x Nuage", subtitle: "Cette année", chart: chart3)
            
            let view4 = UIView.loadFromNibNamed(nibNamed: "ChartView") as! ChartView
            view4.load(title: "Prod. x Humidité", subtitle: "Cette année", chart: chart4)
            
            cell.loadViews(views: [view1, view2, view3, view4])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,1:
            return 200
        default:
            return 300
        }
    }
    
    func updateData(){
        self.loadingView.alpha = 0
        self.loadingView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.loadingView.alpha = 1
        })
        switch self.currentTimeScale {
        case .day:
            self.topDateLabel.text = self.currentDate.toString()
            self.compareDateLabel.text = "vs \(self.currentDate.previousDay().toString())"
        case .month:
            self.topDateLabel.text = "\(self.currentDate.month())-\(self.currentDate.year())"
            self.compareDateLabel.text = "vs \(self.currentDate.previousMonth().month())-\(self.currentDate.previousMonth().year())"
        case .year:
            self.topDateLabel.text = "\(self.currentDate.year())"
            self.compareDateLabel.text = "vs \(self.currentDate.previousYear().year())"
        }
        
        self.getDailyData(date: self.currentDate)
        self.getMonthlyData(date: self.currentDate)
        self.getYearlyData(date: self.currentDate)
        
        self.downloadGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            UIView.animate(withDuration: 0.25, animations: { 
                self.loadingView.alpha = 0
            }, completion: { (finished) in
                self.loadingView.isHidden = true
            })
            self.tableView.reloadData()
        }))
    }

    
    func didSelect(date: Date, scale: TimeScale){
        self.currentDate = date
        self.currentTimeScale = scale
        self.cacheManager.empty()
        self.updateData()
    }
    
    @IBAction func previousPeriod(_ sender: Any) {
        switch self.currentTimeScale {
        case .day:
            self.currentDate = self.currentDate.previousDay()
        case .month:
            self.currentDate = self.currentDate.previousMonth()
        case .year:
            self.currentDate = self.currentDate.previousYear()
        }
        self.updateData()
    }
    
    
    @IBAction func nextPeriod(_ sender: Any) {
        switch self.currentTimeScale {
        case .day:
            self.currentDate = self.currentDate.nextDay()
        case .month:
            self.currentDate = self.currentDate.nextMonth()
        case .year:
            self.currentDate = self.currentDate.nextYear()
        }
        self.updateData()
    }
    
    @IBAction func showCalendarAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        controller.delegate = self
        controller.date = self.currentDate
        controller.timeScale = self.currentTimeScale
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func showHistoryAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        controller.date = self.currentDate
        controller.data = self.allProduction.map({ (prods) -> [Production] in
            prods.reversed()
        }).reversed()
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func addRecordAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddRecordViewController") as! AddRecordViewController
        controller.date = self.currentDate
        if let prod = self.production{
            controller.production = prod
        }else{
            let prod = Array(self.allProduction.joined()).last!.copy()
            prod.date = self.currentDate
            controller.production = prod
        }
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
}
