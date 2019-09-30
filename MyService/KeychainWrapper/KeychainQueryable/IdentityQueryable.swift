//
//  IdentityQueryable.swift
//  MyService
//
//  Created by Hsiao, Wayne on 2019/9/29.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

/// Keychain wrapper for item class [kSecClassIdentity](https://developer.apple.com/documentation/security/ksecclassidentity)
public struct IdentityQueryable: KeychainItemQueryable {
    let service: String
    let accessGroup: String?
    
    public var getquery: [String: Any] {
        var query = [
            kSecClass.toString: kSecClassGenericPassword,
            kSecAttrService.toString: service
            ] as [String : Any]
        
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
          query[String(kSecAttrAccessGroup)] = accessGroup
        }
        #endif
        return query
    }
    
    public init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
}
