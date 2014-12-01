//
//  MailXSend.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

class MailXSend {
    var to = [(String, String?)]()
    var from: String = ""
    var fromName: String?
    var addressbook = [String]()
    var cc = [(String, String?)]()
    var bcc = [(String, String?)]()
    var reply: String?
    var subject: String?
    var project: String = ""
    var vars = [String: String]()
    var links = [String: String]()
    var headers = [String: String]()
    
    var config: MailConfig
    
    var params = [String: AnyObject]()
    
    init(config: MailConfig) {
        self.config = config
    }
    
    // set email and name
    func add_to(address: String, _ name: String? = nil) {
        self.to.append((address, name))
    }
    
    // set addressbook
    func add_addressbook(addressbook: String) {
        self.addressbook.append(addressbook)
    }
    
    func set_from(address: String) {
        self.from = address
    }
    
    func set_fromname(name: String) {
        self.fromName = name
    }
    
    func set_reply(reply: String) {
        self.reply = reply
    }
    
    func add_cc(address: String, _ name: String? = nil) {
        self.cc.append((address, name))
    }
    
    func add_bcc(address: String, _ name: String? = nil) {
        self.bcc.append((address, name))
    }
    
    func set_subject(subject: String) {
        self.subject = subject
    }
    
    func set_project(project: String) {
        self.project = project
    }
    
    func add_var(key: String, _ val: String) {
        self.vars[key] = val
    }
    
    func add_link(key: String, _ val: String) {
        self.links[key] = val
    }
    
    func add_header(key: String, _ val: String) {
        self.headers[key] = val
    }
    
    func build_params() -> [String: AnyObject] {
        var params = [String: AnyObject]()
        if self.to.count > 0 {
            var toValue = ""
            for toItem in self.to {
                let address = toItem.0
                var name = ""
                if let mailName = toItem.1 {
                    name = mailName
                }
                toValue += name + "<" + address + ">,"
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
        
        params["from"] = self.from.0
        
        if self.fromName != nil {
            params["from_name"] = self.fromName!
        }
        
        if self.reply != nil {
            params["reply"] = self.reply!
        }
        
        if self.cc.count > 0 {
            var ccValue = ""
            for ccItem in self.cc {
                let address = ccItem.0
                var name = ""
                if let mailName = ccItem.1 {
                    name = mailName
                }
                ccValue += name + "<" + address + ">,"
            }
            params["cc"] = ccValue.substringToIndex(advance(ccValue.startIndex, ccValue.utf16Count-1))
        }
        
        if self.bcc.count > 0 {
            var bccValue = ""
            for bccItem in self.bcc {
                let address = bccItem.0
                var name = ""
                if let mailName = bccItem.1 {
                    name = mailName
                }
                bccValue += name + "<" + address + ">,"
            }
            params["bcc"] = bccValue.substringToIndex(advance(bccValue.startIndex, bccValue.utf16Count-1))
        }
        
        params["project"] = self.project
        
        if self.subject != nil {
            params["subject"] = self.subject!
        } else {
            params["subject"] = self.project
        }
        
        // vars and links and headers need json
        if self.vars.count > 0 {
            let jsonData = NSJSONSerialization.dataWithJSONObject(self.vars, options: nil, error: nil)
            if let data = jsonData {
                params["vars"] = NSString(data: data, encoding: NSUTF8StringEncoding)
            }
        }
        
        if self.links.count > 0 {
            let jsonData = NSJSONSerialization.dataWithJSONObject(self.links, options: nil, error: nil)
            if let data = jsonData {
                params["links"] = NSString(data: data, encoding: NSUTF8StringEncoding)
            }
        }
        
        if self.headers.count > 0 {
            let jsonData = NSJSONSerialization.dataWithJSONObject(self.headers, options: nil, error: nil)
            if let data = jsonData {
                params["headers"] = NSString(data: data, encoding: NSUTF8StringEncoding)
            }
        }
        
        return params
    }
    
    func xsend(completion: (AnyObject? -> Void)? = nil) {
        let mail = Mail(config: self.config)
        mail.send(build_params()) {
            json in
            if completion != nil {
                completion!(json)
            }
        }
    }
}