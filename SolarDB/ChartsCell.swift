//
//  ChartsCell.swift
//  SolarDB
//
//  Created by Florent THOMAS-MOREL on 11/19/16.
//  Copyright © 2016 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

let kChartsCell = "kChartsCell"

class ChartsCell: UITableViewCell{
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var slidingView: UIView!
    
    var futurePage: Int!
    var currentPage = 0
    var numberOfViews: Int!
    var originalWidth: CGFloat!
    var referencePoint: CGPoint!
    
    override func layoutSubviews() {
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOpacity = 0.2
        self.shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.shadowView.layer.shadowRadius = 2
        
    
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delegate = self
        self.slidingView.addGestureRecognizer(panGesture)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: self)
            return fabs(velocity.y) < fabs(velocity.x)
        }
        return true
    }
    
    func handlePanGesture(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            self.referencePoint = gesture.translation(in: self.frontView)
            break
        case .changed:
            self.slidingView.frame.origin.x = referencePoint!.x + gesture.translation(in: self.frontView).x - referencePoint!.x - CGFloat(self.currentPage) * self.originalWidth + (self.currentPage == 0 ? 8.0 : 0.0)
            self.futurePage = Int(-self.slidingView.frame.origin.x/(self.originalWidth/2))
            self.futurePage = (gesture.translation(in: self.frontView).x < 0 ? self.currentPage+1 : self.futurePage)
            self.futurePage = (gesture.translation(in: self.frontView).x > 0 ? self.currentPage-1 : self.futurePage)
            self.futurePage = (self.futurePage > self.numberOfViews-1 ? self.numberOfViews-1 : self.futurePage)
            self.futurePage = (self.futurePage < 0 ? 0 : self.futurePage)
            print(self.futurePage)
            break
        default:
            self.currentPage = self.futurePage
            self.pageControl.currentPage = self.currentPage
            UIView.animate(withDuration: 0.25, animations: { 
                self.slidingView.frame.origin.x = -CGFloat(self.currentPage) * (self.originalWidth) - CGFloat(self.currentPage-1) * 8
            })
            break
        }
    }
    
    func loadViews(views: [ChartView]){
        self.numberOfViews = views.count
        self.pageControl.numberOfPages = views.count
        self.pageControl.currentPage = 0
        self.originalWidth = self.frame.width-16
        self.slidingView.frame.size.width = self.originalWidth * CGFloat(views.count) + CGFloat(8*views.count)
        self.slidingView.frame.origin.x = 8
        self.slidingView.removeAllSubviews()
        for i in 0...views.count-1{
            let view = views[i]
            view.frame.origin.x = CGFloat(i) * (originalWidth + 8)
            view.frame.size.width = originalWidth-16
            view.frame.size.height = self.slidingView.frame.height
            view.generateChart()
            view.chartView.subviews[0].frame.size.width = originalWidth-16
            view.chartView.subviews[0].frame.size.height += 30
            self.slidingView.addSubview(view)
        }
    }
}
