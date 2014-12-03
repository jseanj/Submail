//
//  Mail.swift
//  Submail
//
//  Created by jin.shang on 14-11-23.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import UIKit
import Alamofire

public class Mail {
    var params = [String: AnyObject]()
    var signType: String = "normal"
    var appId: String = ""
    var appKey: String = ""
    
    init(config: MailConfig) {
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
        let api = "http://114.80.208.100:83/mail/send.json"
        var requestParams = [String: AnyObject]()
        if params != nil {
            requestParams = params!
        }
        if let appid = self.params["appid"] as? String {
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
                //println(requestParams)
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
        }
    }
    
    public func xsend(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "http://114.80.208.100:83/mail/xsend.json"
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
        let api = "http://114.80.208.100:83/addressbook/mail/subscribe.json"
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
                println(requestParams)
                self.post(api, params: requestParams) {
                    JSON in
                    completion(JSON)
                }
            }
        }
    }
    
    public func unsubscribe(params: [String: AnyObject]?, completion: AnyObject? -> Void) {
        // API httpRequest URL
        let api = "http://114.80.208.100:83/addressbook/mail/unsubscribe.json"
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
        /*let fileURL = NSBundle.mainBundle()
            .URLForResource("test", withExtension: "png")
        Alamofire.upload(.POST, "http://114.80.208.100:83/mail/send.json", fileURL!).responseJSON {
            (_, _, JSON, _) in
            println("upload")
            println(JSON)
        }*/
        
        var imaget = UIImage(named: "test.png")
        let imageData = UIImagePNGRepresentation(imaget)
        
        let dict = params as Dictionary<String, String>
        let urlRequest = urlRequestWithComponents("http://114.80.208.100:83/mail/send.json", parameters: dict, imageData: imageData)
        
        Alamofire.upload(urlRequest.0, urlRequest.1)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
            }
            .responseJSON { (request, response, JSON, error) in
                println("REQUEST \(request)")
                println("RESPONSE \(response)")
                println("JSON \(JSON)")
                println("ERROR \(error)")
        }
        
        
        Alamofire.request(.POST, api, parameters: params).responseJSON {
            (_, _, JSON, _) in
            println(JSON)
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
        let api = "http://114.80.208.100:83/service/timestamp.json"
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

        println("===\(signStr)")
        
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
    
    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        println("____________")
        println(uploadData)
        println("____________")

        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
}
