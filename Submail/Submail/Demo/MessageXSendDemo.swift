//
//  MessageXSendDemo.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

public class MessageXSendDemo {
    public class func demo() {
        var submail = MessageXSend(config: MessageConfig())
        submail.add_to("18616761881")
        submail.set_project("kZ9Ky3")
        submail.add_var("code", "198276")
        submail.xsend()
    }
}