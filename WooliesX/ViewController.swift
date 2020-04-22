//
//  ViewController.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import UIKit
import WooliesAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let client = DogImageClient()
        
        client?.getImages { response in
            
            switch response {
            case .success(let images):
                
                print(images.first?.breeds?.first?.minLifeSpan)
                print(images.count)
            case .failure:
                
                print("error")
            }
        }
    }

}
