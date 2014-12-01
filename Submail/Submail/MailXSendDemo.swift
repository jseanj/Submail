//
//  MailXSendDemo.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

public class MailXSendDemo {
    public func demo() {
        var submail = MailXSend(config: MailConfig())
        submail.add_to("leo@submail.cn", "leo")
        submail.set_project("uigGk1")
        submail.add_var("name", "leo")
        submail.add_var("age", "32")
        submail.add_link("developer", "http://submail.cn/chs/developer")
        submail.add_link("store", "http://submail.cn/chs/store")
        submail.add_header("X-Accept", "zh-cn")
        submail.add_header("X-Mailer", "leo App")
        
        submail.xsend()
    }
}