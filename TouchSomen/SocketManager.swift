//
//  ScoketIOManager.swift
//  TouchSomen
//
//  Created by 村上晋太郎 on 2016/11/30.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import Cocoa
import SocketIO

protocol SocketManagerDelegate: class {
    func socketManager(_ manager: SocketManager, didReceiveData: [String: Any])
}

class SocketManager: NSObject {
    let url: URL
    var socket: SocketIOClient
    weak var delegate: SocketManagerDelegate? = nil
    
    override init() {
        url = URL(string:"http://smurakami.com:61130/")!
        socket = SocketIOClient(socketURL: url, config: [.log(false), .forcePolling(true)])
        super.init()
        
        socket.on("connect") { data, ack in
            print("socket connected!!")
        }
        socket.on("disconnect") { data, ack in
            print("socket disconnected!!")
        }
        
        socket.on("from_server") { [weak self] data, emitter in
            guard let `self` = self else {return}
            if let message = data as? [[String: Any]] {
                if let data = message.first {
                    self.delegate?.socketManager(self, didReceiveData: data)
                }
            }
        }
        socket.connect()
    }
    
    func emit(message: String) {
        socket.emit("from_client", message)
    }
    
    static let shared = SocketManager()
}
