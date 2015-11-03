//
//  MultipeerManager.swift
//  TouchDesign
//
//  Created by Harry Shamansky on 10/12/15. Based on Ralf Ebert's work.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MultipeerManagerDelegate {
    func connectedDevicesChanged(manager: MultipeerManager, connectedDevices: [String])
    func commandDidSend(manager: MultipeerManager, command: Command)
}

class MultipeerManager: NSObject {

    private let myPeerId: MCPeerID
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    var delegate: MultipeerManagerDelegate?
    
    override init() {
        
        #if os(iOS)
            myPeerId = MCPeerID(displayName: UIDevice.currentDevice().name)
        #else
            myPeerId = MCPeerID(displayName: NSHost.currentHost().localizedName!)
        #endif
            
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: kMultipeerServiceType)
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: kMultipeerServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session.delegate = self
        return session
    }()
    
    func sendCommand(command: Command) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(command)
        if session.connectedPeers.count > 0 {
            var error : NSError?
            do {
                try self.session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
            } catch let error1 as NSError {
                error = error1
                NSLog("%@", "\(error)")
            }
        }
    }
}

extension MultipeerManager: MCSessionDelegate {
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        delegate?.connectedDevicesChanged(self, connectedDevices: session.connectedPeers.map({ $0.displayName }))
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data.length) bytes")
        
        guard let command = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Command else {
            return
        }
        
        delegate?.commandDidSend(self, command: command)
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
}

extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: ((Bool, MCSession) -> Void)) {
        
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
}

extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // TODO: display graphic here if peer is disconnected
    }
    
}