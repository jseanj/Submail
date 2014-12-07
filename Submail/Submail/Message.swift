//
//  Message.swift
//  Submail
//
//  Created by jin.shang on 14-11-23.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

public class Message {
    var params = [String: AnyObject]()
    var signType: String = "normal"
    var appId: String = ""
    var appKey: String = ""
    
    init(config: MessageConfig) {
        self.params = config.params
        if let appid = self.params["appid"] as? String {
            self.appId = appid
        }
        if let appkey = self.params["appkey"] as? String {
            self.appKey = appkey
        }
    }
    
    // MARK: - API
    public func send(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/message/send.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                requestParams["sign_type"] = "normal"
                let signTypeState = ["normal", "md5", "sha1"]
                if let sign = self.params["sign_type"] as String? {
                    for state in signTypeState {
                        if state == sign {
                            self.signType = sign
                            requestParams["sign_type"] = sign
                            break
                        }
                    }
                }
                requestParams["signature"] = self.createSignature(requestParams)
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
        }
    }
    
    public func xsend(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/message/xsend.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                requestParams["sign_type"] = "normal"
                let signTypeState = ["normal", "md5", "sha1"]
                if let sign = self.params["sign_type"] as String? {
                    for state in signTypeState {
                        if state == sign {
                            self.signType = sign
                            requestParams["sign_type"] = sign
                            break
                        }
                    }
                }
                requestParams["signature"] = self.createSignature(requestParams)
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
        }
    }
    
    public func subscribe(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/addressbook/message/subscribe.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                requestParams["sign_type"] = "normal"
                let signTypeState = ["normal", "md5", "sha1"]
                if let sign = self.params["sign_type"] as String? {
                    for state in signTypeState {
                        if state == sign {
                            self.signType = sign
                            requestParams["sign_type"] = sign
                            break
                        }
                    }
                }
                requestParams["signature"] = self.createSignature(requestParams)
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
        }
    }
    
    public func unsubscribe(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/addressbook/message/unsubscribe.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                requestParams["sign_type"] = "normal"
                let signTypeState = ["normal", "md5", "sha1"]
                if let sign = self.params["sign_type"] as String? {
                    for state in signTypeState {
                        if state == sign {
                            self.signType = sign
                            requestParams["sign_type"] = sign
                            break
                        }
                    }
                }
                requestParams["signature"] = self.createSignature(requestParams)
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
        }
    }
    
    // MARK: - private helper method
    private func post(api: String, params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        let manager = AFHTTPRequestOperationManager()
        
        manager.POST(api, parameters: params, success: {
            _, JSON in
            completion(JSON)
        }) {
            _, _ in
        }
    }
    
    private func get(api: String, params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        let manager = AFHTTPRequestOperationManager()
        manager.GET(api, parameters: params, success: {
            _, JSON in
            completion(JSON)
        }) {
            _, _ in
        }
    }
    
    private func getTimestamp(completion: String -> Void) {
        let api = "https://api.submail.cn/service/timestamp.json"
        get(api, params: nil) {
            JSON in
            if let json = JSON as [String: AnyObject]? {
                if let timestamp = json["timestamp"] as NSNumber? {
                    completion(timestamp.stringValue)
                }
            }
        }
    }
    
    private func createSignature(params: [String: AnyObject]) -> String {
        if self.signType == "normal" {
            if let signature = self.params["appkey"] as String? {
                return signature
            } else {
                return ""
            }
        } else {
            return buildSignature(params)
        }
    }
    
    private func buildSignature(params: [String: AnyObject]) -> String {
        let sortedArray = sorted(params.keys.array)
        var signStr = ""
        for key in sortedArray {
            if key != "attachments" {
                if let value = params[key] as? String {
                    signStr += key + "=" + value + "&"
                }
            }
        }
        signStr = signStr.substringToIndex(advance(signStr.startIndex, signStr.utf16Count-1))
        
        signStr = self.appId + self.appKey + signStr + self.appId + self.appKey
        
        if self.signType == "md5" {
            if let md5 = signStr.md5() {
                return md5
            } else {
                return ""
            }
        } else if self.signType == "sha1" {
            if let sha1 = signStr.sha1() {
                return sha1
            } else {
                return ""
            }
        }
        return ""
    }
}
