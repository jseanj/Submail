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
    var from = [(String, String?)]()
    var addressbook = [String]()
    
    // set email and name
    func add_to(address: String, name: String? = nil) {
        self.to.append((address, name))
    }
    
    // set addressbook
    func add_addressbook(addressbook: String) {
        self.addressbook.append(addressbook)
    }
    
    func add_from(address: String, name: String? = nil) {
        
    }
}
