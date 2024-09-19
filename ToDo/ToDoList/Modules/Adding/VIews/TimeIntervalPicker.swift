//
//  TimeIntervalPicker.swift
//  ToDo
//
//  Created by Nikita Stepanov on 18.09.2024.
//

import Foundation
import UIKit

class TimeIntervalPicker: NSObject,
                          UIPickerViewDelegate,
                          UIPickerViewDataSource {
    var didSelectDates: ((_ start: Date,
                          _ end: Date) -> Void)?
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override init() {
        super.init()
        setUp()
    }
    
    private var days = [Date]()
    private var startTimes = [Date]()
    private var endTimes = [Date]()
    
    let dayFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    var inputView: UIView {
        return pickerView
    }
    
    func setUp() {
        dayFormatter.dateFormat = "EE d MMM"
        timeFormatter.timeStyle = .short
        days = setDays()
        startTimes = getTimes(of: days.first!)
        endTimes = getTimes(of: days.first!)
    }
    
    // MARK: - UIPickerViewDelegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return startTimes.count
        case 2:
            return endTimes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = .black
        label.textAlignment = .center
        label.font = K.mainFont
        
        var text = ""
        switch component {
        case 0:
            text = getDayString(from: days[row])
        case 1:
            text = getTimeString(from: startTimes[row])
        case 2:
            text = getTimeString(from: endTimes[row])
        default:
            break
        }
        
        label.text = text
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        let dayIndex = pickerView.selectedRow(inComponent: 0)
        
        if component == 0 {
            let selectedDay = days[dayIndex]
            startTimes = getTimes(of: selectedDay)
            endTimes = getTimes(of: selectedDay)
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        }
        
        let startTimeIndex = pickerView.selectedRow(inComponent: 1)
        let endTimeIndex = pickerView.selectedRow(inComponent: 2)
        
        guard days.indices.contains(dayIndex),
              startTimes.indices.contains(startTimeIndex),
              endTimes.indices.contains(endTimeIndex) else { return }
        
        let startTime = startTimes[startTimeIndex]
        var endTime = endTimes[endTimeIndex]
        
        if startTime >= endTime {
            let nextValidEndTimeIndex = startTimeIndex + 1
            if endTimes.indices.contains(nextValidEndTimeIndex) {
                pickerView.selectRow(nextValidEndTimeIndex,
                                     inComponent: 2,
                                     animated: true)
                endTime = endTimes[nextValidEndTimeIndex]
            } else {
                pickerView.selectRow(endTimes.count - 1,
                                     inComponent: 2,
                                     animated: true)
                endTime = endTimes.last!
            }
        }
        didSelectDates?(startTime, endTime)
    }
    
    // MARK: - Private helpers
    private func getDays(of date: Date) -> [Date] {
        var dates = [Date]()
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: date)
        let oneMonthFromNow = calendar.date(byAdding: .day,
                                            value: 30,
                                            to: currentDate)
        guard let endDate = oneMonthFromNow else { return dates }
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day,
                                        value: 1,
                                        to: currentDate)!
        }
        return dates
    }
    
    private func getTimes(of date: Date) -> [Date] {
        var times = [Date]()
        var currentDate = Calendar.current.startOfDay(for: date)
        let calendar = Calendar.current
        let interval = 60
        while Calendar.current.component(.hour, from: currentDate) < 23 {
            times.append(currentDate)
            currentDate = calendar.date(byAdding: .minute,
                                        value: interval,
                                        to: currentDate) ?? Date()
        }
        if let lastHour = Calendar.current.date(bySettingHour: 23,
                                                minute: 00,
                                                second: 0,
                                                of: date) {
            times.append(lastHour)
        }
        if let lastMinute = Calendar.current.date(bySettingHour: 23,
                                                  minute: 59,
                                                  second: 0,
                                                  of: date) {
            times.append(lastMinute)
        }
        return times
    }
    
    private func setDays() -> [Date] {
        return getDays(of: Date())
    }
    
    private func setStartTimes() -> [Date] {
        return getTimes(of: Date())
    }
    
    private func setEndTimes() -> [Date] {
        return getTimes(of: Date())
    }
    
    private func getDayString(from date: Date) -> String {
        return dayFormatter.string(from: date)
    }
    
    private func getTimeString(from date: Date) -> String {
        return timeFormatter.string(from: date)
    }
}
