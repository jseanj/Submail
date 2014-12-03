//
//  ViewController.swift
//  Submail
//
//  Created by jin.shang on 14-11-23.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("mail send")
        MailSendDemo.demo()
//        println("mail xsend")
//        MailXSendDemo.demo()
//        println("message xsend")
//        MessageXSendDemo.demo()
//        println("address mail subscribe")
//        AddressbookMailSubscribeDemo.demo()
//        println("address mail unsubscribe")
//        AddressbookMailUnsubscribeDemo.demo()
//        println("address message subscribe")
//        AddressbookMessageSubscribeDemo.demo()
//        println("address message unsubscribe")
//        AddressbookMessageUnsubscribeDemo.demo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

