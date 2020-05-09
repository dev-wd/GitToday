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
    var isLoading: PublishSubject<Bool> { get }
    var responseStatus: PublishSubject<ResponseStatus> { get }
    var doneButtonValidation: BehaviorRelay<Bool> { get }
    
    var todayCount: BehaviorRelay<Int> { get }
    var weekCount: BehaviorRelay<Int> { get }
    var monthCount: BehaviorRelay<Int> { get }
    
    var step1: BehaviorSubject<[String]> { get }
    var step2: BehaviorSubject<[String]> { get }
    var step3: BehaviorSubject<[String]> { get }
    var step4: BehaviorSubject<[String]> { get }
    var step5: BehaviorSubject<[String]> { get }
    
    func fetch()
}

class TodayViewController: UIViewController, NCWidgetProviding, FSCalendarDelegate, FSCalendarDataSource,  FSCalendarDelegateAppearance {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var userIDButton: UIButton!
    
    private let backgroundScheduler = SerialDispatchQueueScheduler.init(qos: .background)
    
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
        
        viewModel.isLoading
            .bind(to: indicator.rx.isHidden)
            .disposed(by: bag)
        
        
        viewModel.responseStatus
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { val in
                print("val: ",val)
                switch val {
                case .success:
                    print("success")
                    self.calendar.isHidden = false
                    self.nextButton.isHidden = false
                    self.prevButton.isHidden = false
                    self.updateButton.isHidden = false
                    self.userIDButton.isHidden = true
                    self.calendar.reloadData()
                case .failed(GitTodayError.userIDLoadError):
                    print("put your github id")
                    self.calendar.isHidden = true
                    self.nextButton.isHidden = true
                    self.updateButton.isHidden = true
                    self.prevButton.isHidden = true
                    self.userIDButton.isHidden = false
                    
                case .failed(_):
                    print("unknown")
                }
            }).disposed(by: bag)
        
        updateButton.rx
            .tap
            .subscribe(onNext:{
                viewModel.fetch()
                self.calendar.reloadData()
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
        
    }
    
    private func layout() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scrollDirection = .horizontal
        calendar.scrollEnabled = true
        calendar.appearance.borderRadius = 0.1
        calendar.appearance.selectionColor = UIColor(white: 1, alpha: 0)
        calendar.appearance.titleSelectionColor = UIColor.black
        calendar.allowsSelection = false
        calendar.appearance.todayColor = UIColor(white: 1, alpha: 0)
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.titleDefaultColor = UIColor(named: "titleDefaultColor")
        indicator.startAnimating()
        userIDButton.isHidden = true
        
    }
    
    internal func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            calendar.scope = .month
            prevButton.isHidden = false
            nextButton.isHidden = false
            updateButton.isHidden = false
            preferredContentSize = CGSize(width: 0, height: 280)
        } else {
            calendar.scope = .week
            self.currentPage = Date()
            self.calendar.setCurrentPage(self.currentPage!, animated: false)
            prevButton.isHidden = true
            nextButton.isHidden = true
            updateButton.isHidden = true
            preferredContentSize = maxSize
        }
    }
    
    @IBAction func userIDButtonTapped(_ sender: Any) {
        let myAppUrl = NSURL(string: "calendarViewController://")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success) {
                print("failed")
            }
        })
    }
    @IBAction func prevButtonTapped(_ sender: Any) {
        self.moveCurrentPage(moveUp: false)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
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
