//
//  CalendarViewController.swift
//  GitToday
//
//  Created by Mainea on 1/30/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import UIKit
import FSCalendar
import UserNotifications

protocol CalendarViewBindable {
    func fetch()
    func fetchUpdate(id: String)
    
    var todayCount: Int { set get }
    var weekCount: Int { set get }
    var monthCount: Int { set get }
    
    var step1: [String] { set get }
    var step2: [String] { set get }
    var step3: [String] { set get}
    var step4: [String] { set get }
    var step5: [String] { set get }
    
}


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance  {
    
    private let viewModel: CalendarViewBindable = CalendarViewModel()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var idButtonTitle: UIButton!
    @IBOutlet weak var todayNumber: UILabel!
    @IBOutlet weak var weekNumber: UILabel!
    @IBOutlet weak var monthNumber: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchUpdate(id: "dev-wd")
        layout()
        calenderLayout()
        
    }
    
    private func layout() {
        todayNumber.text = String(viewModel.todayCount)
        monthNumber.text = String(viewModel.monthCount)
        weekNumber.text = String(viewModel.weekCount)
    }
    
    
    private func calenderLayout() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scrollDirection = .vertical
        calendar.appearance.borderRadius = 0.1
        calendar.appearance.selectionColor = UIColor(white: 1, alpha: 0)
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.borderSelectionColor = UIColor.red
        calendar.appearance.todayColor = UIColor(white: 1, alpha: 0)
    }
    
    private let gregorian: Calendar = Calendar(identifier: .gregorian)
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    func calendar(_ _calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString : String = dateFormatter.string(from:date)
        if viewModel.step2.contains(dateString) {
            return UIColor.init(hex: 0xc6e48b)
        }else if viewModel.step3.contains(dateString) {
            return UIColor.init(hex: 0x7bc96f)
        }else if viewModel.step4.contains(dateString) {
            return UIColor.init(hex: 0x239a3b)
        }else if viewModel.step5.contains(dateString) {
            return UIColor.init(hex: 0x196127)
        }
        else{
            return nil
        }
    }
    
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return dateFormatter.date(from: dateFormatter.string(from: Date()))!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return dateFormatter.date(from: dateFormatter.string(from: Date(timeIntervalSinceNow:-32140800)))!
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        viewModel.fetch()
        print("fetch")
    }
    
    @IBAction func prevMonthTapped(_ sender: Any) {
        self.moveCurrentPage(moveUp: false)
    }
    @IBAction func nextMonthTapped(_ sender: Any) {
        self.moveCurrentPage(moveUp: true)
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
}



// alarm logic

//let center = UNUserNotificationCenter.current()
//center.requestAuthorization(options: [.alert, .sound]) {
//    (granted, error) in
//}
//let content = UNMutableNotificationContent()
//content.title = "Hey I'm notification!"
//content.body = "Look at me!"
//
//let date = Date().addingTimeInterval(40)
//print("date: ",date)
//let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//
//let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//let uuidString = UUID().uuidString
//
//let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//center.add(request) {(error) in
//    print(error)
//}
