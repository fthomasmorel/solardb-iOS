//
//  CalendarViewController.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/29/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import CVCalendar

protocol CalendarDelegate {
    func didSelect(date: Date, scale: TimeScale)
}

enum TimeScale {
    case day
    case month
    case year
}

class CalendarViewController: UIViewController, MenuViewDelegate, CVCalendarViewDelegate{

    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeScaleButton: UISegmentedControl!
    
    var date = Date()
    var didChangeMonth = false
    var timeScale: TimeScale = .day
    var delegate: CalendarDelegate?
    
    override func viewDidLoad() {
        self.calendarView.calendarAppearanceDelegate = self
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calendarView.toggleViewWithDate(self.date)
        self.updateDateLabel(date: self.date)
        switch self.timeScale {
        case .day:
            self.timeScaleButton.selectedSegmentIndex = 0
        case .month:
            self.timeScaleButton.selectedSegmentIndex = 1
        case .year:
            self.timeScaleButton.selectedSegmentIndex = 2
        }
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.monday
    }
    
    public func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func didShowNextMonthView(_ date: Foundation.Date){
        self.didChangeMonth = true
        if timeScale == .year {
            self.calendarView.toggleViewWithDate(self.date.nextYear())
        }
    }
    
    func didShowPreviousMonthView(_ date: Foundation.Date){
        self.didChangeMonth = true
        if timeScale == .year {
            self.calendarView.toggleViewWithDate(self.date.previousYear())
        }
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        let cvDate = dayView.date!
        let year = String(cvDate.year)
        let month = String(format: "%02d", cvDate.month)
        let day = String(format: "%02d", cvDate.day)
        
        
        let dateString = "\(day)-\(month)-\(year)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: dateString)!.midnight()
        self.date = date
        self.updateDateLabel(date: date)
    }
    
    func updateDateLabel(date: Date){
        let dateFormatter = DateFormatter()
        let months = dateFormatter.monthSymbols
        let monthSymbol = months?[Int(date.month())!-1]
        switch self.timeScale {
        case .day:
            self.dateLabel.text = "\(date.day()) \(monthSymbol!) \(date.year())"
            break
        case .month:
            self.dateLabel.text = "(\(date.day())) \(monthSymbol!) \(date.year())"
            break
        case .year:
            self.dateLabel.text = "(\(date.day()) \(monthSymbol!)) \(date.year())"
            break
        }
    }
    @IBAction func didChangeScale(_ sender: Any) {
        var timeScale:TimeScale = .day
        switch self.timeScaleButton.selectedSegmentIndex {
        case 0:
            timeScale = .day
            break
        case 1:
            timeScale = .month
            break
        default:
            timeScale = .year
            break
        }
        
        if timeScale == self.timeScale {
            self.date = Date()
            self.calendarView.toggleViewWithDate(self.date)
        }
        self.timeScale = timeScale
        self.updateDateLabel(date: self.date)
    }
    
    @IBAction func goToToday(_ sender: Any) {
        self.calendarView.toggleViewWithDate(Date())
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.delegate?.didSelect(date: date, scale: self.timeScale)
        self.dismiss(animated: true, completion: nil)
    }
}
