//
//  SomenView.swift
//  TouchSomen
//
//  Created by 村上晋太郎 on 2016/11/25.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import Cocoa

class SomenView: NSView {
    
    var somens: [Somen] = []
    var pos = CGPoint()
    var timer: Timer? = nil
    var somenCounter = 0
    
    func setup() {
        startUpdate()
    }
    
    private func startUpdate() {
        timer = Timer.scheduledTimer(timeInterval: 1.0/60, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func update() {
        pos.x -= 4
        if pos.x < -bounds.size.width {
            pos.x += bounds.size.width
        }
        
        for somen in somens {
            somen.pos.x -= 4
            if somen.pos.x <= -80 {
                somen.isValid = false
            }
        }
        
        if somenCounter == 0 {
            addSomen()
            somenCounter = 40 + Int(arc4random() % 60)
        }
        
        somens = somens.filter { $0.isValid }
        
        somenCounter -= 1
        needsDisplay = true
    }
    
    func addSomen() {
        let somen = Somen()
        somen.pos.x = bounds.size.width
        somens.append(somen)
    }
    
    override func touchesBegan(with event: NSEvent) {
        if let touch = event.touches(matching: .began, in: self).first, touch.type == .direct {
            let location = touch.location(in: self)
            for somen in somens {
                if somen.hit(point: location) {
                    somen.isValid = false
                }
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawTake(dirtyRect)
        
//        for somen in somens {
//            somen.drawShadow(dirtyRect)
//        }
//        
        drawWater(dirtyRect)
        
        for somen in somens {
            somen.draw(dirtyRect)
        }
    }
    
    func drawTake(_ dirtyRect: NSRect) {
        let take = NSImage(named: "take")!
        take.draw(in: dirtyRect)
    }
    
    func drawWater(_ dirtyRect: NSRect) {
        let water = NSImage(named: "water")!
        var rect = dirtyRect
        let scale: CGFloat = 0.7
        rect.origin.y += rect.size.height * (1 - scale) / 2
        rect.origin.x = pos.x
        rect.size.height *= scale
        water.draw(in: rect)
        rect.origin.x += rect.size.width
        water.draw(in: rect)
    }
}

class Somen: NSObject {
    var pos = NSPoint()
    let images = Somen.getImages()
    var imageIndex = 0
    var counter = 0
    
    let shadow = NSImage(named: "soumen_shadow")!
    let hitWidth: CGFloat = 60 // 当たり判定
    var isValid = true
    
    static func getImages() -> [NSImage] {
        let imageNames = [
            "soumen1", "soumen2", "soumen3", "soumen4", "soumen5", "soumen6", "soumen7", "soumen8", "soumen9", "soumen10",
            ]
        return imageNames.map { NSImage(named: $0)! }
    }
    
    func hit(point: CGPoint) -> Bool {
        return point.x > pos.x && point.x < pos.x + hitWidth
    }
    
    func getSize(_ dirtyRect: NSRect) -> NSSize {
        let image = images.first!
        let height = dirtyRect.size.height * 0.6
        let scale = height / image.size.height
        let size = NSSize(
            width: image.size.width * scale,
            height: image.size.height * scale)
        return size
    }
    
    func draw(_ dirtyRect: NSRect) {
        let height = dirtyRect.size.height * 0.6
        pos.y = (dirtyRect.size.height - height) / 2
        
        let size = getSize(dirtyRect)
        
        imageIndex = counter
        images[imageIndex % images.count].draw(in: NSRect(
            origin: pos,
            size: size))
        
//        if counter % 4 == 0 {
//            imageIndex += Int(arc4random() % 2) * 2 - 1
//            if imageIndex < 0 {
//                imageIndex += images.count * 100
//            }
//        }
        counter += 1
    }
    
    func drawShadow(_ dirtyRect: NSRect) {
        let height = dirtyRect.size.height * 0.6
        pos.y = (dirtyRect.size.height - height) / 2
        
        let size = getSize(dirtyRect)
        
        shadow.draw(in: NSRect(
            origin: NSPoint(x: pos.x + 8, y: pos.y),
            size: size))
    }
}

class Hashi: NSObject {
    
}

