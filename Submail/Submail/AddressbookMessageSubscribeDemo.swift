//
//  AddressbookMessageSubscribeDemo.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

public class AddressbookMessageSubscribeDemo {
    public class func demo() {
        var addressbook = AddressbookMessage(config: MessageConfig())
        addressbook.set_address("18616761889")
        addressbook.subscribe()
    }
}