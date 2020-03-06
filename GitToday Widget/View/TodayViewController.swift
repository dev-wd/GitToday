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
import RxSwift
import RxCocoa


protocol TodayViewBindable {
    var isLoading: PublishRelay<Bool> { get }
    //var responseStatus: PublishRelay<ResponseStatus> { get }
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
}
class TodayViewController: UIViewController, NCWidgetProviding, FSCalendarDelegate, FSCalendarDataSource,  FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        bind(viewModel: TodayViewModel())
        layout()
        
    }
    
    private func bind(viewModel:  TodayViewBindable) {
        viewModel.fetch()
        print("fetch")
        
        //        viewModel.todayCount
        //            .subscribe({ val in
        //                self.todayNumber.text = String(val.element!)
        //            }).disposed(by: bag)
        //
        //        viewModel.weekCount
        //            .subscribe({ val in
        //                self.weekNumber.text = String(val.element!)
        //            }).disposed(by: bag)
        //
        //        viewModel.monthCount
        //            .subscribe({ val in
        //                self.monthNumber.text = String(val.element!)
        //            }).disposed(by: bag)
        
        // 결국에 viewModel에서 가지고 오는게 안먹는다는건디
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
        
    }
    
    private func layout() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scrollDirection = .horizontal
        calendar.appearance.borderRadius = 0.1
        calendar.appearance.selectionColor = UIColor(white: 1, alpha: 0)
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.appearance.borderSelectionColor = UIColor.red
        calendar.appearance.todayColor = UIColor(white: 1, alpha: 0)
    }
    
    internal func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            calendar.scope = .month
            preferredContentSize = CGSize(width: 0, height: 280)
        } else {
            calendar.scope = .week
            preferredContentSize = maxSize
        }
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
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController {
    func calendar(_ _calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateString : String = dateFormatter.string(from:date)
        if self.step2.contains(dateString) {
            return UIColor.init(hex: 0xc6e48b)
        } else if self.step3.contains(dateString) {
            return UIColor.init(hex: 0x7bc96f)
        } else if self.step4.contains(dateString) {
            return UIColor.init(hex: 0x239a3b)
        } else if self.step5.contains(dateString) {
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
    
    private func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
    
}
