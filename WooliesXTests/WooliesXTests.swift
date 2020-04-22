//
//  WooliesXTests.swift
//  WooliesXTests
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import XCTest
@testable import WooliesX
@testable import WooliesAPI

class WooliesXTests: XCTestCase {

    func testData() {
        
        let images = getMockImages()
        
        let firstImage = images.first
        
        XCTAssertTrue(images.count > 0, "No media retrieved from the API")
        
        XCTAssertEqual(firstImage?.firstBreed?.name, "American Foxhound", "Breed must be American Foxhound")
        
        XCTAssertEqual(firstImage?.firstBreed?.minLifeSpan, 8, "Minimum life span must be 8 years")
        
        let dogsAge12 = images.filter { $0.firstBreed?.minLifeSpan == 12 }
        
        XCTAssertEqual(dogsAge12.count, 7, "There must be 7 dogs with min age 12")
        
        for dog in dogsAge12 {
            
            XCTAssertEqual(dog.firstBreed?.minLifeSpan, 12, "Minimum life span must be 12 years")
        }
    }

    func getMockImages() -> [DogImage] {
        
        let expectation = self.expectation(description: "no data recieved")
        
        var images = [DogImage]()
        
        DataHelper.getMockImages { (response) in
            
            switch response {
                
            case .success(let _images):
                
                images = _images
                
            case .failure:
                
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        return images
    }
}
