//
//  MailXSendDemo.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

public class MailXSendDemo {
    public class func demo() {
        var submail = MailXSend(config: MailConfig())
        submail.add_to("leo@submail.cn", "leo")
        submail.set_from("no-reply@submail.cn", "SUBMAIL")
        submail.set_project("wAWzY4")
        submail.add_var("name", "leo")
        submail.add_var("age", "32")
        submail.add_link("developer", "http://submail.cn/chs/developer")
        submail.add_link("store", "http://submail.cn/chs/store")
        submail.add_headers("X-Accept", "zh-cn")
        submail.add_headers("X-Mailer", "leo App")
        submail.xsend()
    }
}