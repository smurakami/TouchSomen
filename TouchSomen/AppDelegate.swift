//
//  AppDelegate.swift
//  TouchSomen
//
//  Created by 村上晋太郎 on 2016/11/25.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        _ = SocketManager.shared
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

