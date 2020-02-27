//
//  TodayViewController.swift
//  GitToday Widget
//
//  Created by Mainea on 1/30/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import UIKit
import NotificationCenter
import FSCalendar

class TodayViewController: UIViewController, NCWidgetProviding, FSCalendarDelegate, FSCalendarDataSource,  FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    let somedays : [String]  = ["2019-06-03",
                                "2019-06-06",
                                "2019-06-12",
                                "2019-06-25"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        
        
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scrollDirection = .vertical
        calendar.appearance.borderRadius = 0.1
        calendar.appearance.selectionColor = UIColor(white: 1, alpha: 0)
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.borderSelectionColor = UIColor.red
        calendar.appearance.todayColor = UIColor(white: 1, alpha: 0)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            calendar.scope = .month
            preferredContentSize = CGSize(width: 0, height: 280)
        } else {
            calendar.scope = .week
            preferredContentSize = maxSize
        }
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    func calendar(_ _calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString : String = dateFormatter2.string(from:date)
        if self.somedays.contains(dateString)
        {
            return UIColor.green
        }
        else{
            return nil
        }
    }
    
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return dateFormatter2.date(from: "2020-02-01")!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return dateFormatter2.date(from: "2019-01-01")!
    }
    
    private var currentPage: Date?
    
    private lazy var today: Date = {
        return Date()
    }()
    
    private func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
    
    @IBAction func prevButtonTapped(_ sender: Any) {
        print("tapped")
        self.moveCurrentPage(moveUp: false)
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        print("tapped")
        self.moveCurrentPage(moveUp: true)
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
