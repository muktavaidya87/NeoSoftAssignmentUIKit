//
//  CarouselViewModel.swift
//  NeoSoftAssignmentUIKit
//
//  Created by Mukta on 22/12/24.
//

import Foundation
import Combine

class CarouselViewModel {
    // Observed properties for UIKit
    var currentIndex: Int = 0 {
        didSet {
            notifyObservers()
        }
    }
    var searchText: String = "" {
        didSet {
            notifyObservers()
        }
    }
    
    private let dataModel: DataModel
    private var itemStatistics: ItemStatistics
    
    // Observers (UIKit doesn't have @Published, so we use manual notification)
    private var observers: [AnyObject] = []
    
    // Injected dependencies
    init(dataModel: DataModel, itemStatistics: ItemStatistics) {
        self.dataModel = dataModel
        self.itemStatistics = itemStatistics
    }
    
    // Computed properties for data handling
    var dataImages: [String] {
        return dataModel.images
    }
    
    var currentItems: [Item] {
        return dataModel.categories[currentIndex].items
    }
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return currentItems
        } else {
            return currentItems.filter { $0.displayName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var statistics: (itemCount: Int, topChars: [(Character, Int)]) {
        return itemStatistics.calculateStatistics(for: currentItems)
    }
    
    // Method to set the category index (called by UIKit controllers)
    func setCategoryIndex(_ index: Int) {
        currentIndex = index
    }
    
    // Register an observer to listen for changes
    func addObserver(_ observer: AnyObject) {
        observers.append(observer)
    }
    
    // Notify all observers when data changes
    private func notifyObservers() {
        for observer in observers {
            if let observer = observer as? Observable {
                observer.didUpdateData()
            }
        }
    }
}

// Protocol to inform the observer when the data changes
protocol Observable: AnyObject {
    func didUpdateData()
}
