//
//  CalendarViewController.swift
//  GitToday
//
//  Created by Mainea on 1/30/20.
//  Copyright © 2020 Mainea. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar
import UserNotifications

protocol CalendarViewBindable {
    func fetch()
    func fetchUpdate(id: String)
    
    var todayCount: BehaviorRelay<Int> { get }
    var weekCount: BehaviorRelay<Int> { get }
    var monthCount: BehaviorRelay<Int> { get }
    
    var step1: BehaviorRelay<[String]> { get }
    var step2: BehaviorRelay<[String]> { get }
    var step3: BehaviorRelay<[String]> { get }
    var step4: BehaviorRelay<[String]> { get }
    var step5: BehaviorRelay<[String]> { get }
}


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance  {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var idButtonTitle: UIButton!
    @IBOutlet weak var todayNumber: UILabel!
    @IBOutlet weak var weekNumber: UILabel!
    @IBOutlet weak var monthNumber: UILabel!
    @IBOutlet weak var notificationTime: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var step1: [String] = []
    var step2: [String] = []
    var step3: [String] = []
    var step4: [String] = []
    var step5: [String] = []
    
    
    var bag = DisposeBag()
    
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: CalendarViewModel())
        calenderLayout()
    }
    
    private func bind(viewModel:  CalendarViewBindable) {
        viewModel.fetchUpdate(id: "dev-wd")
        print("fetch")
        
        viewModel.todayCount.subscribe({
            val in
            self.todayNumber.text = String(val.element!)
        }).disposed(by: bag)
        
        viewModel.weekCount.subscribe({
            val in
            self.weekNumber.text = String(val.element!)
        }).disposed(by: bag)
        
        viewModel.monthCount.subscribe({
            val in
            self.monthNumber.text = String(val.element!)
        }).disposed(by: bag)
        
        viewModel.step1.subscribe({
            val in
            self.step1 = val.element!
        }).disposed(by: bag)
        
        viewModel.step2.subscribe({
            val in
            self.step2 = val.element!
        }).disposed(by: bag)
        
        viewModel.step3.subscribe({
            val in
            self.step3 = val.element!
        }).disposed(by: bag)
        
        viewModel.step4.subscribe({
            val in
            self.step4 = val.element!
        }).disposed(by: bag)
        
        viewModel.step5.subscribe({
            val in
            self.step5 = val.element!
        }).disposed(by: bag)
        
        updateButton.rx.tap.subscribe(onNext:{
            viewModel.fetch()
        }).disposed(by: bag)
        
        idButtonTitle.rx.tap.subscribe(onNext:{
            // alert for id change 를 띄워야 한다.
        }).disposed(by: bag)
        
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
        
        if self.step2.contains(dateString) {
            return UIColor.init(hex: 0xc6e48b)
        }else if self.step3.contains(dateString) {
            return UIColor.init(hex: 0x7bc96f)
        }else if self.step4.contains(dateString) {
            return UIColor.init(hex: 0x239a3b)
        }else if self.step5.contains(dateString) {
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
