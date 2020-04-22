//
//  ImageCell.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import UIKit
import WooliesAPI

class ImageCell: UICollectionViewCell {

    @IBOutlet
    private var imageView: UIImageView?
    
    @IBOutlet
    private var nameLabel: UILabel?
    
    @IBOutlet
    private var lifeSpanLabel: UILabel?
    
    func prepare(image: DogImage?) -> UICollectionViewCell {
        
        let breed = image?.firstBreed
        
        if let id = image?.id {
        
            self.setAccessibilityIdentifier(withId: id)
        }
        
        return self.prepare(name: breed?.name, lifeSpan: breed?.lifeSpan, imageUrl: image?.url)
    }
    
    func prepare(name: String?, lifeSpan: String?, imageUrl: String?) -> UICollectionViewCell {
        
        self.imageView?.setImage(imageUrl)
        
        self.nameLabel?.text = name
        
        self.lifeSpanLabel?.text = lifeSpan
        
        self.setupCell()
        
        return self
    }
    
    private func setAccessibilityIdentifier(withId id: String) {
        
        self.accessibilityIdentifier = "cell_\(id)"
        
        self.imageView?.accessibilityIdentifier = "image_\(id)"
        
        self.nameLabel?.accessibilityIdentifier = "name_\(id)"
        
        self.lifeSpanLabel?.accessibilityIdentifier = "lifeSpan_\(id)"
    }

    private func setupCell() {
        
        if #available(iOS 13.0, *) {
            
            self.backgroundColor = .systemGray6
            
            self.borderColor = UIColor.systemGray.withAlphaComponent(0.5)
        }
        else {
            
            self.backgroundColor = .white
            
            self.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        }
        
        self.cornerRadius = 10.0
        
        self.borderWidth = 1.0
        
        self.clipsToBounds = true
    }
    
    class func size(givenWidth: CGFloat, image: DogImage?, columns: CGFloat = 1) -> CGSize {
        
        let margin: CGFloat = 20.0
        
        let bottomContentHeight: CGFloat = 20.0
        
        let maxWidth: CGFloat = (givenWidth / columns) - (margin * 2)
                
        var height: CGFloat = 0.0
        
        if let imageWidth = image?.width, let imageHeight = image?.height {
            
            if imageWidth > imageHeight {

                let scaledWidth = min(maxWidth, CGFloat(imageWidth))
                
                let scale = scaledWidth / CGFloat(imageWidth)
                
                height = CGFloat(imageHeight) * scale
            }
            else {

                let scaledHeight = min(maxWidth, CGFloat(imageHeight))
                                
                height = CGFloat(scaledHeight)
            }
        }
        else {
            
            height = 100
        }
        
        height += bottomContentHeight
        
        if image?.firstBreed?.name != nil {
            
            height += 28
        }
        
        if image?.firstBreed?.lifeSpan != nil {
            
            height += 15
        }
        
        return CGSize(width: (givenWidth / columns), height: height)
    }
}
