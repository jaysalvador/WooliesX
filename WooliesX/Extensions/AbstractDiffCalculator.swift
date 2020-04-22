//
//  AbstractDiffCalculator.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation
import Dwifft

extension AbstractDiffCalculator where Section: Equatable, Value: Equatable {
    
    /// Looks for the `IndexPath` of a particular `Section` and `Item` provided
    /// - Parameter section: the current `Section` object
    /// - Parameter value: the current `Item` object
    func indexPath(forSection section: Section, value: Value) -> IndexPath? {
        
        let numberOfSections = self.numberOfSections()

        for sectionIndex in 0..<numberOfSections {

            if self.value(forSection: sectionIndex) == section {
             
                let numberOfObjects = self.numberOfObjects(inSection: sectionIndex)
                
                for itemIndex in 0..<numberOfObjects {
                    
                    let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                    
                    if self.value(atIndexPath: indexPath) == value {
                        
                        return indexPath
                    }
                }
            }
        }

        return nil
    }
    
    /// get the `(Section, Value)` tuple based on `IndexPath`
    /// - Parameter indexPath: `IndexPath` to lookup
    func sectionAndValue(atIndexPath indexPath: IndexPath) -> (Section, Value) {
        
        return (self.value(forSection: indexPath.section), self.value(atIndexPath: indexPath))
    }
}
