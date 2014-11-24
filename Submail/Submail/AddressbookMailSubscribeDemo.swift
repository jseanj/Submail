//
//  AddressbookMailSubscribeDemo.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

public class AddressbookMailSubscribeDemo {
    public class func demo() {
        var addressbook = AddressbookMail(config: MailConfig())
        addressbook.set_address("leo@apple.cn", "leo")
        addressbook.subscribe()
    }
}