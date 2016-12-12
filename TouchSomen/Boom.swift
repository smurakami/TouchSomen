//
//  Boom.swift
//  TouchSomen
//
//  Created by 村上晋太郎 on 2016/12/12.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import Cocoa

class Boom: NSObject {
    class func pow() {
        let rect = NSScreen.main()?.frame
        let window = NSWindow(contentRect: rect!, styleMask: NSWindowStyleMask.borderless, backing: .buffered, defer: false)
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        window.alphaValue = 1
        window.makeKeyAndOrderFront(NSApplication.shared())
        window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.statusWindow))
        let iv = NSImageView(frame: window.contentView!.bounds)
        iv.wantsLayer = true
        iv.image = NSImage(named: "boom")
        window.contentView!.addSubview(iv)
        
        iv.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 0.2
            animation.toValue = 3
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 00
        
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        group.fillMode = kCAFillModeForwards
        group.isRemovedOnCompletion = false
        group.animations = [animation, opacityAnimation]
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            print(window)
        }
        iv.layer?.add(group, forKey: "")
        CATransaction.commit()
    }

}
