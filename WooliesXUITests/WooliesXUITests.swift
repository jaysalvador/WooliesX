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
        
        let firstItemId = "r1xXEgcNX"
        
        let firstCell = self.app.collectionViews.cells["cell_\(firstItemId)"]
        
        let firstLabel = self.app.staticTexts["name_\(firstItemId)"].firstMatch.label
        
        XCTAssertEqual(firstCell.exists, true, "Rottweiler cell must be first cell")
        
        XCTAssertEqual(firstLabel, "Rottweiler", "value must be American Foxhound")
        
        let button = self.app.buttons.element
        
        button.tap()
        
        let lastCell = self.app.collectionViews.cells["cell_\(firstItemId)"]
        
        var identifier: String? = ""
        
        // Swipe down until it is visible
        while !self.isVisible(element: lastCell) {
            
            let currentIdentifier = self.app.collectionViews.cells.allElementsBoundByIndex.last?.identifier
            
            if identifier != currentIdentifier {

                identifier = currentIdentifier
                
                self.app.swipeUp()
            }
            else {
                
                // end of swiping
                
                XCTAssert(false, "Unable to find Element \(firstItemId)")
                
                break
            }
        }
        
        //"American Bully"
                
        let lastLabel = self.app.staticTexts["name_\(firstItemId)"].label

        XCTAssertEqual(lastLabel, "Rottweiler", "Invalid value (American Bully)")
    }

    private func isVisible(element: XCUIElement) -> Bool {
        
        guard element.exists && !element.frame.isEmpty else {
            
            return false
        }
        
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(element.frame)
    }
}
