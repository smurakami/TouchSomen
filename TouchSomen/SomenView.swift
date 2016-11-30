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
    var hashis: [Hashi] = []
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
            somen.update()
        }
        
        for hashi in hashis {
            hashi.update()
        }
        
        if somenCounter == 0 {
            somenCounter = 40 + Int(arc4random() % 60)
        }
        
        somens = somens.filter { $0.isValid }
        hashis = hashis.filter { $0.isValid }
        
        somenCounter -= 1
        needsDisplay = true
    }
    
    func addSomen(at point: NSPoint) {
        let somen = Somen()
//        let size = somen.getSize(bounds)
//        somen.pos = point
        somen.pos.x = point.x - 20
        somen.pos.y = bounds.size.height
        somens.append(somen)
    }
    
    func addHashi(at point: NSPoint) {
        let hashi = Hashi()
        let size = hashi.getSize(bounds)
        hashi.pos = point
        hashi.pos.x -= size.width/2
        hashi.pos.y = 0
        hashis.append(hashi)
    }
    
    override func touchesBegan(with event: NSEvent) {
        if let touch = event.touches(matching: .began, in: self).first, touch.type == .direct {
            let location = touch.location(in: self)
            
            let rightArea: CGFloat = 60
            if location.x > bounds.size.width - rightArea {
                addSomen(at: location)
            } else {
                addHashi(at: location)
                for somen in somens {
                    if somen.hit(point: location) {
                        somen.remove()
                    }
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
        
        for hashi in hashis {
            hashi.draw(dirtyRect)
        }
        
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
    var removeTime = 0
    var isRemoving = false
    
    let shadow = NSImage(named: "soumen_shadow")!
    let hitWidth: CGFloat = 40.5 // 当たり判定
    var isValid = true
    
    static func getImages() -> [NSImage] {
        let imageNames = [
//            "soumen1", "soumen2", "soumen3", "soumen4", "soumen5", "soumen6", "soumen7", "soumen8", "soumen9", "soumen10",
            "soumen_1",
            "soumen_2",
            "soumen_3",
            "soumen_4",
            ]
        return imageNames.map { NSImage(named: $0)! }
    }
    
    func remove() {
        removeTime = counter
        isRemoving = true
    }
    
    func hit(point point_: CGPoint) -> Bool {
        var point = point_
        point.x += 4 * 9
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
    
    func update() {
        pos.x -= 4
        
        if isRemoving {
            let duration = counter - removeTime
            
            if duration > 10 {
                pos.y -= 4
            }
        } else {
            if pos.y > 0 {
                pos.y -= 4
            } else {
                pos.y = 0
            }
        }
        
        if pos.x <= -80 {
            isValid = false
        }
        
        if pos.y >= 80 {
            isValid = false
        }
    }
    
    func draw(_ dirtyRect: NSRect) {
        let height = dirtyRect.size.height * 0.6
        var pos = self.pos
        pos.y += (dirtyRect.size.height - height) / 2
        let size = getSize(dirtyRect)
        
        images[imageIndex % images.count].draw(in: NSRect(
            origin: pos,
            size: size))
        
        if counter % 4 == 0 {
            imageIndex += Int(arc4random() % 2) * 2 - 1
            if imageIndex < 0 {
                imageIndex += images.count * 100
            }
        }
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
    var pos = NSPoint()
    let images = Hashi.getImages()
    var counter = 0
    
    var isValid = true
    
    static func getImages() -> [NSImage] {
        let imageNames = [ "hashi_100", "hashi_101", "hashi_102", "hashi_103", "hashi_104", "hashi_105", "hashi_106", "hashi_107", "hashi_108", "hashi_109", "hashi_110", "hashi_111", "hashi_112", "hashi_113", "hashi_114", "hashi_115", "hashi_116", "hashi_117", "hashi_118", ]
        return imageNames.map { NSImage(named: $0)! }
    }
    
    func update() {
        counter += 1
        if counter == images.count {
            isValid = false
        }
    }
    
    func draw(_ dirtyRect: NSRect) {
        let imageIndex = counter % images.count
        let image = images[imageIndex]
        
        let size = getSize(dirtyRect)
        image.draw(in: NSRect(origin: pos, size: size))
    }
    
    func getSize(_ dirtyRect: NSRect) -> NSSize {
        let image = images.first!
        let height = dirtyRect.size.height * 0.9
        let scale = height / image.size.height
        let size = NSSize(
            width: image.size.width * scale,
            height: image.size.height * scale)
        return size
    }
}

