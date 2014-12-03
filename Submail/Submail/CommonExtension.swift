//
//  CommonExtension.swift
//  Submail
//
//  Created by jins on 14/12/1.
//  Copyright (c) 2014年 jin.shang. All rights reserved.
//

import Foundation

/*extension String {
    /** Calculate MD5 hash */
    public func md5() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.md5()?.toHexString()
    }
    
    public func sha1() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.sha1()?.toHexString()
    }
}*/

extension NSData {
    
    public func checksum() -> UInt16 {
        var s:UInt32 = 0;
        
        var bytesArray = self.bytes();
        
        for (var i = 0; i < bytesArray.count; i++) {
            var b = bytesArray[i]
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536;
        return UInt16(s);
    }
    
    public func md5() -> NSData? {
        return MD5(self).calculate()
    }
    
    public func sha1() -> NSData? {
        return SHA1(self).calculate()
    }
    
    func bytes() -> [Byte] {
        let count = self.length / sizeof(Byte)
        var bytesArray = [Byte](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        return bytesArray
    }
    
    func toHexString() -> String {
        let count = self.length / sizeof(Byte)
        var bytesArray = [Byte](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        
        var s:String = "";
        for byte in bytesArray {
            s = s + NSString(format:"%02X", byte)
        }
        return s;
    }

}

extension NSMutableData {
    
    /** Convenient way to append bytes */
    internal func appendBytes(arrayOfBytes: [Byte]) {
        self.appendBytes(arrayOfBytes, length: arrayOfBytes.count)
    }
}

extension Int {
    /** Array of bytes with optional padding (little-endian) */
    public func bytes(_ totalBytes: Int = sizeof(Int)) -> [Byte] {
        return arrayOfBytes(self, length: totalBytes)
    }
}

class MD5 {
    
    /** specifies the per-round shift amounts */
    private let s: [UInt32] = [7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
        5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
        4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
        6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21]
    
    /** binary integer part of the sines of integers (Radians) */
    private let k: [UInt32] = [0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,
        0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,
        0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,
        0x6b901122,0xfd987193,0xa679438e,0x49b40821,
        0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,
        0xd62f105d,0x2441453,0xd8a1e681,0xe7d3fbc8,
        0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,
        0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,
        0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,
        0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,
        0x289b7ec6,0xeaa127fa,0xd4ef3085,0x4881d05,
        0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,
        0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,
        0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,
        0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,
        0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391]
    
    private let h:[UInt32] = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]
    
    var message: NSData
    
    init(_ message: NSData) {
        self.message = message
    }
    
    /** Common part for hash calculation. Prepare header data. */
    func prepare(_ len:Int = 64) -> NSMutableData {
        var tmpMessage: NSMutableData = NSMutableData(data: self.message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit (Byte with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        while tmpMessage.length % len != (len - 8) {
            tmpMessage.appendBytes([0x00])
        }
        
        return tmpMessage
    }
    
    func calculate() -> NSData {
        var tmpMessage = prepare()
        
        // hash values
        var hh = h
        
        // Step 2. Append Length a 64-bit representation of lengthInBits
        var lengthInBits = (message.length * 8)
        var lengthBytes = lengthInBits.bytes(64 / 8)
        tmpMessage.appendBytes(reverse(lengthBytes));
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        var leftMessageBytes = tmpMessage.length
        for var i = 0; i < tmpMessage.length; i = i + chunkSizeBytes, leftMessageBytes -= chunkSizeBytes {
            let chunk = tmpMessage.subdataWithRange(NSRange(location: i, length: min(chunkSizeBytes,leftMessageBytes)))
            
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15
            var M:[UInt32] = [UInt32](count: 16, repeatedValue: 0)
            for x in 0..<M.count {
                chunk.getBytes(&M[x], range:NSRange(location:x * sizeofValue(M[x]), length: sizeofValue(M[x])));
            }
            
            // Initialize hash value for this chunk:
            var A:UInt32 = hh[0]
            var B:UInt32 = hh[1]
            var C:UInt32 = hh[2]
            var D:UInt32 = hh[3]
            
            var dTemp:UInt32 = 0
            
            // Main loop
            for j in 0..<k.count {
                var g = 0
                var F:UInt32 = 0
                
                switch (j) {
                case 0...15:
                    F = (B & C) | ((~B) & D)
                    g = j
                    break
                case 16...31:
                    F = (D & B) | (~D & C)
                    g = (5 * j + 1) % 16
                    break
                case 32...47:
                    F = B ^ C ^ D
                    g = (3 * j + 5) % 16
                    break
                case 48...63:
                    F = C ^ (B | (~D))
                    g = (7 * j) % 16
                    break
                default:
                    break
                }
                dTemp = D
                D = C
                C = B
                B = B &+ rotateLeft((A &+ F &+ k[j] &+ M[g]), s[j])
                A = dTemp
            }
            
            hh[0] = hh[0] &+ A
            hh[1] = hh[1] &+ B
            hh[2] = hh[2] &+ C
            hh[3] = hh[3] &+ D
        }
        
        var buf: NSMutableData = NSMutableData();
        hh.map({ (item) -> () in
            var i:UInt32 = item.littleEndian
            buf.appendBytes(&i, length: sizeofValue(i))
        })
        
        return buf.copy() as NSData;
    }
}

class SHA1 {
    
    private let h:[UInt32] = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0]
    
    var message: NSData
    
    init(_ message: NSData) {
        self.message = message
    }
    
    /** Common part for hash calculation. Prepare header data. */
    func prepare(_ len:Int = 64) -> NSMutableData {
        var tmpMessage: NSMutableData = NSMutableData(data: self.message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit (Byte with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        while tmpMessage.length % len != (len - 8) {
            tmpMessage.appendBytes([0x00])
        }
        
        return tmpMessage
    }
    
    func calculate() -> NSData {
        var tmpMessage = self.prepare()
        
        // hash values
        var hh = h
        
        // append message length, in a 64-bit big-endian integer. So now the message length is a multiple of 512 bits.
        tmpMessage.appendBytes((message.length * 8).bytes(64 / 8));
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        var leftMessageBytes = tmpMessage.length
        for var i = 0; i < tmpMessage.length; i = i + chunkSizeBytes, leftMessageBytes -= chunkSizeBytes {
            let chunk = tmpMessage.subdataWithRange(NSRange(location: i, length: min(chunkSizeBytes,leftMessageBytes)))
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
            // Extend the sixteen 32-bit words into eighty 32-bit words:
            var M:[UInt32] = [UInt32](count: 80, repeatedValue: 0)
            for x in 0..<M.count {
                switch (x) {
                case 0...15:
                    var le:UInt32 = 0
                    chunk.getBytes(&le, range:NSRange(location:x * sizeofValue(M[x]), length: sizeofValue(M[x])));
                    M[x] = le.bigEndian
                    break
                default:
                    M[x] = rotateLeft(M[x-3] ^ M[x-8] ^ M[x-14] ^ M[x-16], 1)
                    break
                }
            }
            
            var A = hh[0]
            var B = hh[1]
            var C = hh[2]
            var D = hh[3]
            var E = hh[4]
            
            // Main loop
            for j in 0...79 {
                var f: UInt32 = 0;
                var k: UInt32 = 0
                
                switch (j) {
                case 0...19:
                    f = (B & C) | ((~B) & D)
                    k = 0x5A827999
                    break
                case 20...39:
                    f = B ^ C ^ D
                    k = 0x6ED9EBA1
                    break
                case 40...59:
                    f = (B & C) | (B & D) | (C & D)
                    k = 0x8F1BBCDC
                    break
                case 60...79:
                    f = B ^ C ^ D
                    k = 0xCA62C1D6
                    break
                default:
                    break
                }
                
                var temp = (rotateLeft(A,5) &+ f &+ E &+ M[j] &+ k) & 0xffffffff
                E = D
                D = C
                C = rotateLeft(B, 30)
                B = A
                A = temp
                
            }
            
            hh[0] = (hh[0] &+ A) & 0xffffffff
            hh[1] = (hh[1] &+ B) & 0xffffffff
            hh[2] = (hh[2] &+ C) & 0xffffffff
            hh[3] = (hh[3] &+ D) & 0xffffffff
            hh[4] = (hh[4] &+ E) & 0xffffffff
        }
        
        // Produce the final hash value (big-endian) as a 160 bit number:
        var buf: NSMutableData = NSMutableData();
        hh.map({ (item) -> () in
            var i:UInt32 = item.bigEndian
            buf.appendBytes(&i, length: sizeofValue(i))
        })
        
        return buf.copy() as NSData;
    }
}

func rotateLeft(v:UInt32, n:UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}

func arrayOfBytes<T>(value:T, length:Int? = nil) -> [Byte] {
    let totalBytes = length ?? (sizeofValue(value) * 8)
    var v = value
    
    var valuePointer = UnsafeMutablePointer<T>.alloc(1)
    valuePointer.memory = value
    
    var bytesPointer = UnsafeMutablePointer<Byte>(valuePointer)
    var bytes = [Byte](count: totalBytes, repeatedValue: 0)
    for j in 0..<min(sizeof(T),totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).memory
    }
    
    valuePointer.destroy()
    valuePointer.dealloc(1)
    
    return bytes
}
