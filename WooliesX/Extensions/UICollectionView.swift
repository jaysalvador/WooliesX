//
//  UICollectionView.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // MARK: Convenience - Registration
    
    /// Helper function to register cells based on the UICollectionViewCell name as the reuse identifier
    /// - Parameter cell: custom `UICollectionViewCell` class
    func register(cell: UICollectionViewCell.Type) {
        
        let name = String(describing: cell)
        
        self.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
    
    // MARK: Convenience - Dequeueing
    
    /// Helper function to dequeue cells based on the UICollectionViewCell name as the reuse identifier
    /// - Parameter cell: custom `UICollectionViewCell` class
    /// - Parameter indexPath: `IndexPath` of the cell
    func dequeueReusable<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? {
        
        let name = String(describing: cell)
        
        return self.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T
    }
    
    // MARK: Convenience - Layouts
    
    var flowLayout: UICollectionViewFlowLayout? {
        
        return self.collectionViewLayout as? UICollectionViewFlowLayout
    }
}
