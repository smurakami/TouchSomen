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
        }
        
        if somenCounter == 0 {
            addSomen()
            somenCounter = 40 + Int(arc4random() % 60)
        }
        
        somens = somens.filter { $0.pos.x >= -80 }
        
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
            somens = somens.filter { !$0.hit(point: location) }
        }
    }
    
    override func touchesEnded(with event: NSEvent) {
    }
    
    override func touchesMoved(with event: NSEvent) {
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawTake(dirtyRect)
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
    let image = NSImage(named: "soumen")!
    let hitWidth: CGFloat = 60 // 当たり判定
    func hit(point: CGPoint) -> Bool {
        return point.x > pos.x && point.x < pos.x + hitWidth
    }
    
    func draw(_ dirtyRect: NSRect) {
        let height = dirtyRect.size.height * 0.6
        pos.y = (dirtyRect.size.height - height) / 2
        let scale = height / image.size.height
        let size = NSSize(
            width: image.size.width * scale,
            height: image.size.height * scale)
        
        image.draw(in: NSRect(
            origin: pos,
            size: size))
    }
}

