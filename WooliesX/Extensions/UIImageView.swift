//
//  UIImageView.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import UIKit
import Kingfisher

typealias ImageDownloadedCallback = ((UIImage?) -> Void)

extension UIImageView {
    
    func setImage(_ stringUrl: String?, clearCache: Bool? = false, onImageDownloaded: ImageDownloadedCallback? = nil) {
        
        self.image = nil
        
        guard let stringUrl = stringUrl else {
            
            return
        }
        
        guard let url = URL(string: stringUrl) else {
            
            return
        }
        
        self.setImage(url, clearCache: clearCache, onImageDownloaded: onImageDownloaded)
    }
    
    func setImage(_ url: URL?, clearCache: Bool? = false, indicatorType: IndicatorType? = .activity, onImageDownloaded: ImageDownloadedCallback? = nil) {
        
        self.image = nil
        
        guard let url = url else {
            
            return
        }
        
        if clearCache == true {
        
            let cache = ImageCache.default
        
            cache.removeImage(forKey: url.absoluteString)
        }
        
        self.kf.indicatorType = indicatorType ?? .none
        
        self.kf.setImage(
            with: ImageResource(downloadURL: url, cacheKey: url.absoluteString),
            placeholder: nil,
            options: nil,
            progressBlock: nil) { [weak self] (response) in
                
                switch response {
                case .success(let result):
                    
                    onImageDownloaded?(result.image)
                    
                case .failure(let error):
                    
                    print(error)
                    
                    onImageDownloaded?(nil)
                }
                
                self?.contentMode = .scaleAspectFit
                self?.setNeedsLayout()
        }
    }
}
