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
        
        return self.prepare(name: breed?.name, lifeSpan: breed?.lifeSpan, imageUrl: image?.url)
    }
    
    func prepare(name: String?, lifeSpan: String?, imageUrl: String?) -> UICollectionViewCell {
        
        self.nameLabel?.text = name
        
        self.lifeSpanLabel?.text = lifeSpan
        
        self.imageView?.setImage(imageUrl)
        
        return self
    }

}
