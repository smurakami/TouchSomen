//
//  ScoketIOManager.swift
//  TouchSomen
//
//  Created by 村上晋太郎 on 2016/11/30.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import Cocoa
import SocketIO

@objc protocol SocketManagerDelegate: class {
    @objc optional func socketManager(_ manager: SocketManager, didReceiveSomen data: [String: Any])
}

class SocketManager: NSObject {
    let url: URL
    var socket: SocketIOClient
    weak var delegate: SocketManagerDelegate? = nil
    
    override init() {
//        url = URL(string:"http://smurakami.com:61130/")!
        url = URL(string: "http://localhost:61130")!
        socket = SocketIOClient(socketURL: url, config: [.log(false), .forcePolling(true)])
        super.init()
        
        socket.on("connect") { data, ack in
            print("socket connected!!")
        }
        
        socket.on("disconnect") { data, ack in
            print("socket disconnected!!")
        }
        
        socket.on("somen") { [weak self] data, ack in
            guard let `self` = self else {return}
            if let dictarray = data as? [[String: Any]],
                let data = dictarray.first {
                    self.delegate?.socketManager?(self, didReceiveSomen: data)
            }
        }
        
        socket.on("greeting") { data, ack in
            ack.with([
                "type": "normal",
                "index": SomenParam.shared.index
                ])
        }
        
        socket.connect()
    }
    
    func emit(event: String, data: SocketData) {
        socket.emit(event, data)
    }
    
    static let shared = SocketManager()
}
