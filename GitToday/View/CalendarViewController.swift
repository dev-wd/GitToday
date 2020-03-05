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
import JGProgressHUD

protocol CalendarViewBindable {
    
    var isLoading: PublishRelay<Bool> { get }
    var responseStatus: PublishRelay<ResponseStatus> { get }
    var doneButtonValidation: BehaviorRelay<Bool> { get }
    
    var todayCount: BehaviorRelay<Int> { get }
    var weekCount: BehaviorRelay<Int> { get }
    var monthCount: BehaviorRelay<Int> { get }
    
    var step1: BehaviorRelay<[String]> { get }
    var step2: BehaviorRelay<[String]> { get }
    var step3: BehaviorRelay<[String]> { get }
    var step4: BehaviorRelay<[String]> { get }
    var step5: BehaviorRelay<[String]> { get }
    
    func fetch()
    func fetchUpdate(id: String)
}


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance  {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var idButtonTitle: UIButton!
    @IBOutlet weak var todayNumber: UILabel!
    @IBOutlet weak var weekNumber: UILabel!
    @IBOutlet weak var monthNumber: UILabel!
    
    @IBOutlet weak var alarmButton: UIButton!
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
    private let gregorian: Calendar = Calendar(identifier: .gregorian)
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: CalendarViewModel())
        calenderLayout()
    }
    
    private func bind(viewModel:  CalendarViewBindable) {
        viewModel.fetch()
        print("fetch")
        
        viewModel.todayCount
            .subscribe({ val in
                self.todayNumber.text = String(val.element!)
            }).disposed(by: bag)
        
        viewModel.weekCount
            .subscribe({ val in
                self.weekNumber.text = String(val.element!)
            }).disposed(by: bag)
        
        viewModel.monthCount
            .subscribe({ val in
                self.monthNumber.text = String(val.element!)
            }).disposed(by: bag)
        
        viewModel.step1
            .subscribe({ val in
                self.step1 = val.element!
            }).disposed(by: bag)
        
        viewModel.step2
            .subscribe({ val in
                self.step2 = val.element!
            }).disposed(by: bag)
        
        viewModel.step3
            .subscribe({ val in
                self.step3 = val.element!
            }).disposed(by: bag)
        
        viewModel.step4
            .subscribe({ val in
                self.step4 = val.element!
            }).disposed(by: bag)
        
        viewModel.step5
            .subscribe({ val in
                self.step5 = val.element!
            }).disposed(by: bag)
        
        viewModel.isLoading
            .subscribe(onNext: { val in
                if val == false {
                    self.hud.textLabel.text = "Success"
                    self.hud.detailTextLabel.text = nil
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.dismiss()
                } else {
                    self.hud.show(in: self.view)
                    self.hud.textLabel.text = "Loadding"
                    self.hud.indicatorView = JGProgressHUDIndicatorView()
                }
            }).disposed(by: bag)
        
        // error 종류에 따라 다르게 딜링해줘야지
        viewModel.responseStatus
            .subscribe(onNext: {val in
                switch val {
                case .success:
                    print("succ")
                case .failed(GitTodayError.userIDLoadError):
                    print("fail")
                case .failed(GitTodayError.userIDSaveError):
                    print("fail")
                case .failed(GitTodayError.networkError):
                    print("fail")
                case .failed(_):
                    print("fail")
                }
            }).disposed(by: bag)
        
        updateButton.rx.tap.subscribe(onNext:{
            viewModel.fetch()
        }).disposed(by: bag)
        
        idButtonTitle.rx.tap.subscribe(onNext:{
            let alert = UIAlertController(title: "GitHub ID", message: "", preferredStyle: UIAlertController.Style.alert)
            let done = UIAlertAction(title:"Done", style: .default) { (action) in
                viewModel.fetchUpdate(id: (alert.textFields?[0].text!)!)
            }
            let cancel = UIAlertAction(title:"Cancel", style: .cancel)
            
            alert.addTextField() { textField in
                textField.placeholder = "input your GitHub ID"
            }
            alert.addAction(cancel)
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
            // 이런게 문제.. bind 시켜 놓으면 dependency가 있으니까 !!!!
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
}

extension CalendarViewController {
    
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
