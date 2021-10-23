//
//  CalendarViewController.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 22/10/21.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var collectionView: JTAppleCalendarView!
    
    var selectDates: [Date]?
    let today = Date()
    var firstDate: Date?
    var twoDatesAlreadySelected: Bool {
        return firstDate != nil && collectionView.selectedDates.count > 1
    }
    var loading = true
    
    var onSelectDates: (([Date]) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dates = self.selectDates {
            collectionView.scrollToDate(dates.last!) {
                self.collectionView.selectDates(dates)
                self.loading = false
            }
        } else {
            collectionView.scrollToDate(today) {
                self.collectionView.selectDates([self.today])
                self.loading = false
            }
        }
        
        collectionView.scrollToDate(today) {
            self.collectionView.selectDates([self.today])
        }
        
        collectionView.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isRangeSelectionUsed = true
        collectionView.allowsMultipleSelection = true
        
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth && cellState.date >= today {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.lightGray
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        
        cell.selectedView.isHidden = !cellState.isSelected
        
        switch cellState.selectedPosition() {
        case .left:
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .middle:
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = []
        case .right:
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .full:
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        default: break
        }
    }
    
    @IBAction func back() {
        
        if loading { return }
        
        self.dismiss(animated: true) {
            
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        var dateComponent = DateComponents()
        dateComponent.day = 1
        dateComponent.month = 1
        dateComponent.year = Calendar.current.component(.year, from: Date())
        
        let startDate = Calendar.current.date(from: dateComponent) ?? Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date()
        
        print("starDate: \(startDate)")
        print("endDate: \(endDate)")
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       generateInDates: .off,
                                       generateOutDates: .off,
                                       hasStrictBoundaries: false)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
    
        self.calendar(calendar,
                      willDisplay: cell,
                      forItemAt: date,
                      cellState: cellState,
                      indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM YYYY"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        if firstDate != nil {
            calendar.selectDates(from: firstDate!, to: date,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            
            if let onSelect = self.onSelectDates {
                onSelect(collectionView.selectedDates)
                self.back()
            }
            
        } else {
            firstDate = date
        }
        
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        // Avoid select old dates
        if date < today {
            return false
        }
        
        if twoDatesAlreadySelected && cellState.selectionType != .programatic || firstDate != nil && date < (collectionView.selectedDates.first  ?? Date()) {
            firstDate = nil
            let retval = !collectionView.selectedDates.contains(date)
            collectionView.deselectAllDates()
            return retval
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if twoDatesAlreadySelected && cellState.selectionType != .programatic {
            firstDate = nil
            collectionView.deselectAllDates()
            return false
        }
        return true
    }
}
