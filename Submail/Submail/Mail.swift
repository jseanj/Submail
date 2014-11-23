//
//  Mail.swift
//  Submail
//
//  Created by jin.shang on 14-11-23.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation
import Alamofire

public class Mail {
    var params = [String: AnyObject]()
    var signType: String = "normal"
    
    init(config: MailConfig) {
        self.params = config.params
    }
    
    // MARK: - API
    public func send(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/mail/send.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
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
            
            requestParams["signature"] = createSignature()
            
            
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
            
        }
    }
    
    public func xsend(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/mail/xsend.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
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
            
            requestParams["signature"] = createSignature()
            
            
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
            
        }
        
    }
    
    public func subscribe(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/mail/subscribe.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
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
            
            requestParams["signature"] = createSignature()
            
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
            
        }
    }
    
    public func unsubscribe(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "https://api.submail.cn/mail/unsubscribe.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as String? {
            requestParams["appid"] = appid
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
            
            requestParams["signature"] = createSignature()
            
            
            getTimestamp {
                timestamp in
                requestParams["timestamp"] = timestamp
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
            
        }
        
    }
    
    // MARK: - private helper method
    private func post(api: String, params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        Alamofire.request(.POST, api, parameters: params).responseJSON {
            (_, _, JSON, _) in
            completion(JSON)
        }
    }
    
    private func get(api: String, params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        Alamofire.request(.GET, api, parameters: params).responseJSON {
            (_, _, JSON, _) in
            completion(JSON)
        }
    }
    
    private func getTimestamp(completion: String -> Void) {
        let api = "https://api.submail.cn/service/timestamp.json"
        get(api, params: nil) {
            JSON in
            if let json = JSON as [String: AnyObject]? {
                if let timestamp = json["timestamp"] as String? {
                    completion(timestamp)
                }
            }
        }
    }
    
    private func createSignature() -> String {
        if self.signType == "normal" {
            if let signature = self.params["appkey"] as String? {
                return signature
            } else {
                return ""
            }
        } else {
            return buildSignature()
        }
    }
    
    private func buildSignature() -> String {
        return "aa"
    }
}
