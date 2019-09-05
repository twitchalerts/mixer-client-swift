//
//  ChatClient.swift
//  Mixer
//
//  Created by Jack Cook on 1/8/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import Starscream
import SwiftyJSON

/// Used to connect to and communicate with a Mixer chat server. There is no shared session, meaning several chat connections can be made at once.
public class ChatClient: WebSocketAdvancedDelegate {
    
    // MARK: Properties
    
    /// The client's delegate, through which updates and chat messages are relayed to your app.
    public weak var delegate: ChatClientDelegate?
    
    /// The stored authentication key. Will only be generated if MixerSession.sharedSession != nil, and is needed to send chat messages.
    fileprivate var authKey: String?
    
    /// The id of the channel being connected to.
    fileprivate var channelId: Int!
    
    /// The number of the packet being sent.
    fileprivate var packetCount = 0
    
    /// The websocket through which chat data is received and sent.
    fileprivate var socket: WebSocket?
    
    /// Initializes a chat connection, which needs to be stored by your own class.
    public init(delegate chatDelegate: ChatClientDelegate? = nil) {
        delegate = chatDelegate
    }
    
    // MARK: Public Methods
    
    /**
     Requests chat details and uses them to connect to a channel.
    
     :param: channelId The id of the channel being connected to.
     */
    public func joinChannel(_ channelId: Int) {
        self.channelId = channelId
        
        MixerClient.sharedClient.chat.getChatDetailsById(channelId) { (endpoints, authKey, error) in
            guard let endpoints = endpoints else {
                print("channel details did not return endpoints or authkey")
                return
            }
            
            if let authKey = authKey {
                self.authKey = authKey
            }
            
            if let url = URL(string: endpoints[0]) {
                self.socket = WebSocket(url: url, protocols: ["chat", "http-only"])
                self.socket?.advancedDelegate = self
                self.socket?.connect()
            }
        }
    }
    
    /// Disconnects from the chat server.
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    /**
     Sends a packet to the chat server.
     
     :param: packet The packet being sent.
     */
    public func sendPacket(_ packet: ChatSendable) {
        packetCount += 1
        
        guard let socket = socket else {
            return
        }
        
        let packetData = ChatPacket.prepareToSend(packet, count: packetCount)
        socket.write(string: packetData)
    }
    
    // MARK: WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        guard let userId = MixerSession.sharedSession?.user.id, let authKey = authKey else {
            let packet = ChatAuthenticatePacket(channelId: channelId)
            sendPacket(packet)
            
            delegate?.chatDidConnect()
            
            return
        }
        
        delegate?.chatDidConnect()
        
        let packet = ChatAuthenticatePacket(channelId: channelId, userId: userId, authKey: authKey)
        sendPacket(packet)
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: Error?) {
        self.delegate?.chatDidDisconnect(error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String, response: WebSocket.WSResponse) {
        guard let data = text.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("unknown error parsing chat packet")
            return
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                let json = JSON(jsonObject)
                
                if let packet = ChatPacket.receivePacket(json) {
                    self.delegate?.chatReceivedPacket(packet)
                }
            }
        } catch { }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data, response: WebSocket.WSResponse) {}
    
    public func websocketHttpUpgrade(socket: WebSocket, request: String) {}
    
    public func websocketHttpUpgrade(socket: WebSocket, response: String) {}
}

/// The chat client's delegate, through which information is relayed to your app.
public protocol ChatClientDelegate: class {
    
    /// Called when a connection is made to the chat server.
    func chatDidConnect()
    
    /// Called when a disconnection is made from the chat server.
    func chatDidDisconnect(_ error: Error?)
    
    /// Called when a packet is received and interpreted.
    func chatReceivedPacket(_ packet: ChatPacket)
}
