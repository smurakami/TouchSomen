//
//  WindowController.swift
//  TouchSomen
//
//  Created by 村上晋太郎 on 2016/11/25.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    
    override func makeTouchBar() -> NSTouchBar? {
        
        let touchBarIdenitifier = NSTouchBarCustomizationIdentifier(rawValue: "com.tb.TestToolBar")
        let touchBarLabelIdentifier = NSTouchBarItemIdentifier(rawValue: "com.tb.TestToolBar.label")
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = touchBarIdenitifier
        touchBar.defaultItemIdentifiers = [touchBarLabelIdentifier, .fixedSpaceLarge, .otherItemsProxy]
        touchBar.customizationAllowedItemIdentifiers = [touchBarLabelIdentifier]
        
        return touchBar
    }
    
}


extension WindowController: NSTouchBarDelegate {
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        if identifier.rawValue == "com.tb.TestToolBar.label" {
            let custom = NSCustomTouchBarItem(identifier: identifier)
            custom.customizationLabel = "Label"
            let view = SomenView()
            view.setup()
            custom.view = view
            return custom
        }
        
        return nil
    }
}

