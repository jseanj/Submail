//
//  AddressbookMessage.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

class AddressbookMessage {
    var address: String = ""
    var target: String?
    var config: MessageConfig
    
    init(config: MessageConfig) {
        self.config = config
    }
    
    func set_address(address: String, _ name: String? = nil) {
        var addressname = ""
        if name != nil {
            addressname = name!
        }
        self.address = addressname + "<" + address + ">"
    }
    
    func set_addressbook(target: String) {
        self.target = target
    }
    
    func build_params() -> [String: AnyObject] {
        var params = [String: AnyObject]()
        params["address"] = self.address
        if self.target != nil {
            params["target"] = self.target!
        }
        return params
    }
    
    func subscribe(completion: (AnyObject? -> Void)? = nil) {
        let addressbook = Message(config: self.config)
        addressbook.subscribe(build_params()) {
            json in
            if completion != nil {
                completion!(json)
            }
        }
    }
    func unsubscribe(completion: (AnyObject? -> Void)? = nil) {
        let addressbook = Message(config: self.config)
        addressbook.unsubscribe(build_params()) {
            json in
            if completion != nil {
                completion!(json)
            }
        }
    }
}