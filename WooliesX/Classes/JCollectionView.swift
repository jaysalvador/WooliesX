//
//  JCollectionView.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation
import Dwifft

/// Custom `UICollectionViewController` that implements `Dwifft` cell difference calculator for easy reloading of `UICollectionViewCells`
/// `Sections` and `Items` are generic and must adhere to `Equatable` protocol for object comparison in the `diffCalculator` within the `Dwifft` library
class JCollectionViewController<Section: Equatable, Item: Equatable>: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Sections and items
    
    typealias SectionAndItems = (Section, [Item])
    
    var diffCalculator: CollectionViewDiffCalculator<Section, Item>?
    
    var sectionsAndItems: Array<SectionAndItems> {
        
        fatalError()
    }
    
    private var sectionedValues: SectionedValues<Section, Item> {
        
        return SectionedValues<Section, Item>(self.sectionsAndItems)
    }
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError()
    }
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    // MARK: - Outlets
    
    var collectionView: UICollectionView?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupCollectionView()
        
        self.setupNotifications()
        
    }
         
    // MARK: - Setup
    
    private func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    func setupCollectionView() {

        // MARK: Diff calculator

        self.diffCalculator = CollectionViewDiffCalculator(collectionView: self.collectionView, initialSectionedValues: self.sectionedValues)

        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: UICollectionReusableView.self))

        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
    }
    
    // MARK: - Update
    
    /// Calls the diff calculator to compare the sections and items if they have changed based on the `Equatable` definition provided to each of them
    /// - Parameter forced: if `true`, ignores comparison and refreshes the entire collection view
    func updateSectionsAndItems(forced: Bool = false) {
        
        if forced {
            
            self.diffCalculator?.sectionedValues = SectionedValues<Section, Item>([])
        }
        
        self.diffCalculator?.sectionedValues = self.sectionedValues
    }
    
    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if let numberOfSections = self.diffCalculator?.numberOfSections() {
            
            return numberOfSections
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let numberOfObjects = self.diffCalculator?.numberOfObjects(inSection: section) {
            
            return numberOfObjects
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let section = self.diffCalculator?.value(forSection: indexPath.section),
            let item = self.diffCalculator?.value(atIndexPath: indexPath),
            let cell = self.collectionView(collectionView, cellForSection: section, item: item, indexPath: indexPath) {
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    /// High level implementation for `cellForItemAt` to quickly provide the `Section` and `Item` objects easily
    /// - Parameter collectionView: `CollectionView` class
    /// - Parameter section: the current `Section` object
    /// - Parameter item: the current `Item` object
    /// - Parameter indexPath: `IndexPath` of the cell
    func collectionView(_ collectionView: UICollectionView, cellForSection section: Section, item: Item, indexPath: IndexPath) -> UICollectionViewCell? {
        
        fatalError() // needs to be overriden
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let section = self.diffCalculator?.value(forSection: indexPath.section) {
            if let item = self.diffCalculator?.value(atIndexPath: indexPath) {
                
                self.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath, section: section, item: item)
                
            }
        }
        
    }
    
    /// High level implementation for `willDisplayCell` to quickly provide the `Section` and `Item` objects easily
    /// - Parameter collectionView: `CollectionView` class
    /// - Parameter cell: the current cell
    /// - Parameter indexPath: `IndexPath` of the cell
    /// - Parameter section: the current `Section` object
    /// - Parameter item: the current `Item` object
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath, section: Section, item: Item) {
        
        // can be overriden
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let section = self.diffCalculator?.value(forSection: indexPath.section),
            let item = self.diffCalculator?.value(atIndexPath: indexPath) {
            
            self.collectionView(collectionView, didSelectItemAtSection: section, item: item)
            self.collectionView(collectionView, didSelectItemAtSection: section, item: item, indexPath: indexPath)
            
        }
    }
    
    /// High level implementation for `didSelectItemAtSection` to quickly provide the `Section` and `Item` objects easily
    /// - Parameter collectionView: `CollectionView` class
    /// - Parameter section: the current `Section` object
    /// - Parameter item: the current `Item` object
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtSection section: Section, item: Item) {
        
        // can be overriden
    }
    
    /// High level implementation for `didSelectItemAtSection` to quickly provide the `Section` and `Item` objects easily
    /// - Parameter collectionView: `CollectionView` class
    /// - Parameter section: the current `Section` object
    /// - Parameter item: the current `Item` object
    /// - Parameter indexPath: `IndexPath` of the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtSection section: Section, item: Item, indexPath: IndexPath) {
        
        // can be overriden
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let section = self.diffCalculator?.value(forSection: indexPath.section),
            let item = self.diffCalculator?.value(atIndexPath: indexPath),
            let size = self.collectionView(collectionView, layout: collectionViewLayout, sizeForSection: section, item: item, indexPath: indexPath) {
            
            return size
        }
        
        return self.collectionView?.flowLayout?.itemSize ?? CGSize.zero
    }
    
    /// High level implementation for `sizeForSection` to quickly provide the `Section` and `Item` objects easily
    /// - Parameter collectionView: `CollectionView` class
    /// - Parameter collectionViewLayout: `UICollectionViewLayout` class
    /// - Parameter section: the current `Section` object
    /// - Parameter item: the current `Item` object
    /// - Parameter indexPath: `IndexPath` of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForSection section: Section, item: Item, indexPath: IndexPath) -> CGSize? {
        
        return nil
    }
    
    // MARK: - Dwifft convenience
    
    /// gets a particular cell based on the given `Section` and `Item`
    /// - Parameter section: the current `Section` object
    /// - Parameter item: the current `Item` object
    func cell(forSection section: Section, item: Item) -> UICollectionViewCell? {
        
        if let indexPath = self.diffCalculator?.indexPath(forSection: section, value: item) {
            
            return self.collectionView?.cellForItem(at: indexPath)
        }
        
        return nil
    }
    
    func scrollToItem(atSection section: Section, item: Item, scrollPosition: UICollectionView.ScrollPosition = .top, animated: Bool = true) {
        
        if let indexPath = self.diffCalculator?.indexPath(forSection: section, value: item) {
            
            self.collectionView?.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        }
    }
    
    /// Reload items at indexpath
    /// - Parameter section: the current `Section` object
    /// - Parameter item: the current `Item` object
    func reload(atSection section: Section, item: Item) {
        
        if let indexPath = self.diffCalculator?.indexPath(forSection: section, value: item) {
            
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
    
    /// Returns `Section` and `Item`
    /// - Parameter indexPath: given IndexPath
    func sectionAndItem(atIndexPath indexPath: IndexPath) -> (Section, Item)? {
        
        return self.diffCalculator?.sectionAndValue(atIndexPath: indexPath)
    }
    
    // MARK: - Actions
    
    @objc
    func orientationChanged() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(175)) { [weak self] in
            
            self?.updateSectionsAndItems(forced: true)
        }
    }
}
