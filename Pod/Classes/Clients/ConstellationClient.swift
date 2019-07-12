//
//  ConstellationClient.swift
//  Pods
//
//  Created by Jack Cook on 8/10/16.
//
//

import Starscream
import SwiftyJSON

/// Used to connect to and communicate with Mixer's liveloading socket.
public class ConstellationClient: WebSocketAdvancedDelegate {
    
    // MARK: Properties
    
    /// The client's shared instance.
    public class var sharedClient: ConstellationClient {
        struct Static {
            static let instance = ConstellationClient()
        }
        return Static.instance
    }
    
    /// The client's delegate, through which updates are relayed to the app.
    fileprivate weak var delegate: ConstellationClientDelegate?
    
    /// All events that the client is currently subscribed to.
    fileprivate var events = [ConstellationEvent]()
    
    /// The websocket through which constellation data is sent and received.
    fileprivate var socket: WebSocket?
    
    // MARK: Public Methods
    
    /// Makes a connection to constellation through a websocket.
    public func connect(_ delegate: ConstellationClientDelegate) {
        self.delegate = delegate
    
        var request = URLRequest(url: URL(string: "wss://constellation.mixer.com")!)
        request.timeoutInterval = 5
        request.setValue("IOSApp/\(MixerRequest.version) (iOS; \(MixerRequest.deviceName()))", forHTTPHeaderField: "User-Agent")
        
        socket = WebSocket(request: request)
        socket?.advancedDelegate = self
        socket?.connect()
    }
    
    /// Disconnects from constellation.
    public func disconnect() {
        self.socket?.disconnect()
    }
    
    /**
     Sends a packet to constellation.
     
     :param: packet The packet to be sent.
     */
    public func sendPacket(_ packet: ConstellationSendable) {
        guard let socket = socket else {
            return
        }
        
        let packetData = ConstellationPacket.prepareToSend(packet)
        socket.write(string: packetData)
    }
    
    /**
     Subscribes the client to a list of events.
     
     :param: events The list of events to subscribe to.
     */
    public func subscribeToEvents(_ events: [ConstellationEvent]) {
        self.events.append(contentsOf: events)
        
        let subscribePacket = ConstellationLiveSubscribePacket(events: events)
        sendPacket(subscribePacket)
    }
    
    /**
     Unsubscribes the client from a list of events.
     
     :param: events The list of events to unsubscribe from.
     */
    public func unsubscribeFromEvents(_ events: [ConstellationEvent]) {
        for (idx, event) in self.events.enumerated() {
            if events.contains(where: { $0.description == event.description }) {
                self.events.remove(at: idx)
            }
        }
        
        let unsubscribePacket = ConstellationLiveUnsubscribePacket(events: events)
        sendPacket(unsubscribePacket)
    }
    
    /// Unsubscribes the client from all events it is currently subscribed to.
    public func unsubscribeFromAllEvents() {
        let unsubscribePacket = ConstellationLiveUnsubscribePacket(events: events)
        sendPacket(unsubscribePacket)
        
        events = [ConstellationEvent]()
    }
    
    // MARK: WebSocketAdvancedDelegate Methods
    
    public func websocketDidConnect(socket: WebSocket) {
        delegate?.constellationDidConnect()
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: Error?) {
        delegate?.constellationDidDisconnect(error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String, response: WebSocket.WSResponse) {
        guard let data = text.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("unknown error parsing constellation packet: \(text)")
            return
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                let json = JSON(jsonObject)
                
                if let packet = ConstellationPacket.receivePacket(json) {
                    self.delegate?.constellationReceivedPacket(packet)
                }
            }
        } catch {
            print("JSON read failure while parsing constellation packet: \(text)")
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data, response: WebSocket.WSResponse) {}
    
    public func websocketHttpUpgrade(socket: WebSocket, request: String) {}
    
    public func websocketHttpUpgrade(socket: WebSocket, response: String) {}
}

/// The constellation client's delegate, through which information is relayed to the app.
public protocol ConstellationClientDelegate: class {
    
    /// Called when a connection is made to the constellation server.
    func constellationDidConnect()
    
    /// Called when the websocket disconnects, whether on purpose or unexpectedly.
    func constellationDidDisconnect(_ error: Error?)
    
    /// Called when a packet has been received and interpreted.
    func constellationReceivedPacket(_ packet: ConstellationPacket)
}
