//
//  MailSendDemo.swift
//  Submail
//
//  Created by jins on 14/11/24.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

public class MailSendDemo {
    public class func demo() {
        // init MailSend class
        var submail = MailSend(config: MailConfig())
        
        // add email recipient address and name
        submail.add_to("leo@submail.cn", "leo")
        submail.add_cc("mailer@submail.cn")
        submail.add_bcc("leo@drinkfans.com")
        
        // set addressbook sign
        submail.add_addressbook("subscribe")
        
        // set email sender address and name
        submail.set_from("no-reply@submail.cn", "leo")
        
        // set email reply address
        submail.set_reply("service@submail.cn")
        
        // Optional
        // set email text content
        submail.set_text("test SDK text")
        
        // set email html content
        submail.set_html("test SDK html")
        
        // set email subject
        submail.set_subject("testSDK")
        
        // email text content filter
        submail.add_var("name", "leo")
        submail.add_var("age", "32")
        
        // email link content filter
        submail.add_link("developer", "http://submail.cn/chs/developer")
        submail.add_link("store", "http://submail.cn/chs/store")
        
        // email headers
        submail.add_headers("X-Accept", "zh-cn")
        submail.add_headers("X-Mailer", "leo App")
        
        // email attachment
        let file = NSBundle.mainBundle().pathForResource("test", ofType: "png")
        if file != nil {
            submail.add_attachment(file!)
        }

        submail.send()
    }
}