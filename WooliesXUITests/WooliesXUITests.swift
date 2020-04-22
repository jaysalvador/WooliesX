//
//  WooliesXUITests.swift
//  WooliesXUITests
//
//  Created by Jay Salvador on 23/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import XCTest

class WooliesXUITests: XCTestCase {
        
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        self.app = XCUIApplication()
    }
    
    func testExample() {
        
        self.app.launchArguments.append(contentsOf: ["-rootMock"])
        
        self.app.launch()
        
        let firstItemId = "S14n1x9NQ"
        
        let lastItemId = "sqQJDtbpY"
        
        let firstCell = self.app.collectionViews.cells["cell_\(firstItemId)"]
        
        let firstLabel = self.app.staticTexts["name_\(firstItemId)"].label
        
        XCTAssertEqual(firstCell.exists, true, "American Foxhound cell must be first cell")
        
        XCTAssertEqual(firstLabel, "American Foxhound", "value must be American Foxhound")
        
        let button = self.app.buttons.element
        
        button.tap()
        
        let lastCell = self.app.collectionViews.cells["cell_\(lastItemId)"]
        
        var identifier: String? = ""
        
        // Swipe down until it is visible
        while !lastCell.exists {
            
            let currentIdentifier = self.app.collectionViews.cells.allElementsBoundByIndex.last?.identifier
            
            if identifier != currentIdentifier {

                identifier = currentIdentifier
                
                self.app.swipeUp()
            }
            else {
                
                // end of swiping
                
                XCTAssert(false, "Unable to find Element \(lastItemId)")
                
                break
            }
        }
        
        //"American Bully"
                
        let lastLabel = self.app.staticTexts["name_\(lastItemId)"].label

        XCTAssertEqual(lastLabel, "American Bully", "Invalid value (American Bully)")
    }
}
