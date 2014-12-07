//
//  MailSend.swift
//  Submail
//
//  Created by jin.shang on 14-11-23.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

class MailSend {
    var to = [(String, String?)]()
    var from: String = ""
    var fromName: String?
    var addressbook = [String]()
    var cc = [(String, String?)]()
    var bcc = [(String, String?)]()
    var reply: String?
    var subject: String = ""
    var text: String?
    var html: String?
    var vars = [String: String]()
    var links = [String: String]()
    var attachments = [String]()
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
    
    // set from and from_name
    func set_from(address: String, _ name: String? = nil) {
        self.from = address
        self.fromName = name
    }
    
    // set reply address
    func set_reply(reply: String) {
        self.reply = reply
    }
    
    // set cc recipient to array
    func add_cc(address: String, _ name: String? = nil) {
        self.cc.append((address, name))
    }
    
    // set bcc recipient to array
    func add_bcc(address: String, _ name: String? = nil) {
        self.bcc.append((address, name))
    }

    // set email subject
    func set_subject(subject: String) {
        self.subject = subject
    }
    
    // set email text content
    func set_text(text: String) {
        self.text = text
    }
    
    // set email html content
    func set_html(html: String) {
        self.html = html
    }
    
    // set var to array
    func add_var(key: String, _ val: String) {
        self.vars[key] = val
    }
    
    // set link var to array
    func add_link(key: String, _ val: String) {
        self.links[key] = val
    }
    
    // set attachment to array
    func add_attachment(attachment: String) {
        self.attachments.append(attachment)
    }
    
    // set headers to array
    func add_headers(key: String, _ val: String) {
        self.headers[key] = val
    }
    
    // build request params
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
        
        params["from"] = self.from
        
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
        
        params["subject"] = self.subject
        
        if self.text != nil {
            params["text"] = self.text!
        }
        
        if self.html != nil {
            params["html"] = self.html!
        }

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
        
        if self.attachments.count > 0 {
            params["attachments"] = self.attachments
        }
        
        return params
    }
    
    // send mail
    func send(completion: (AnyObject? -> Void)? = nil) {
        let mail = Mail(config: self.config)

        mail.send(build_params()) {
            json in
            if completion != nil {
                completion!(json)
            }
        }
    }
}
