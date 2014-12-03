//
//  Config.swift
//  Submail
//
//  Created by jin.shang on 14-11-23.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

let apiUrl = "http://114.80.208.100:83/"

// Mail Config
let mail_appid = "10034" //"your_mail_app_id"

let mail_appkey = "6e88cf3e26b914c70b9e57b5ebb26b21" //"your_mail_app_key"

let mail_sign_type = "md5"


// Message Config
let message_appid = "10022" //"your_message_app_id"

let message_appkey = "14eae3a3c722f6c3def4204e4b505a21" //"your_message_app_key"

let message_sign_type = "md5"

// Addressbook Config

class MailConfig {
    var params = [String: AnyObject]()
    init() {
        params["appid"] = mail_appid
        params["appkey"] = mail_appkey
        params["sign_type"] = mail_sign_type
    }
}

class MessageConfig {
    var params = [String: AnyObject]()
    init() {
        params["appid"] = message_appid
        params["appkey"] = message_appkey
        params["sign_type"] = message_sign_type
    }
}