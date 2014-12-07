//
//  MessageXSend.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

class MessageXSend {
    var to = [String]()
    var addressbook = [String]()
    var project: String = ""
    var vars = [String: String]()
    
    var config: MessageConfig
    
    var params = [String: AnyObject]()
    
    init(config: MessageConfig) {
        self.config = config
    }
    
    // set message cellphone number
    func add_to(address: String) {
        self.to.append(address)
    }
    
    // set addressbook sign to array
    func add_addressbook(addressbook: String) {
        self.addressbook.append(addressbook)
    }
    
    // set project
    func set_project(project: String) {
        self.project = project
    }
    
    // set var to array
    func add_var(key: String, _ val: String) {
        self.vars[key] = val
    }
    
    // build request params
    func build_params() -> [String: AnyObject] {
        var params = [String: AnyObject]()
        if self.to.count > 0 {
            var toValue = ""
            for toItem in self.to {
                toValue += toItem + ","
            }
            params["to"] = toValue.substringToIndex(advance(toValue.startIndex, toValue.utf16Count-1))
        }
        
        if self.addressbook.count > 0 {
            var addressbookValue = ""
            for addressbookItem in self.addressbook {
                addressbookValue += addressbookItem + ","
            }
            params["addressbook"] = addressbookValue.substringToIndex(advance(addressbookValue.startIndex, addressbookValue.utf16Count-1))
        }

        params["project"] = self.project
        
        if self.vars.count > 0 {
            let jsonData = NSJSONSerialization.dataWithJSONObject(self.vars, options: nil, error: nil)
            if let data = jsonData {
                params["vars"] = NSString(data: data, encoding: NSUTF8StringEncoding)
            }
        }
        
        return params
    }
    
    func xsend(completion: (AnyObject? -> Void)? = nil) {
        let message = Message(config: self.config)
        message.xsend(build_params()) {
            json in
            if completion != nil {
                completion!(json)
            }
        }
    }
}