//
//  CertificateQueryable.swift
//  MyService
//
//  Created by Hsiao, Wayne on 2019/9/29.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation

/// Keychain wrapper for item class [kSecClassCertificate](https://developer.apple.com/documentation/security/ksecclasscertificate).
/// You can check example in the [Apple documentation](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/certificates/storing_a_certificate_in_the_keychain).
public struct CertificateQueryable: KeychainItemQueryable {
    let accessGroup: String?
    let label: String
    
    public var getquery: [String: Any] {
        var query = [
            String(kSecClass): kSecClassGenericPassword
            ] as [String : Any]

        query[kSecAttrLabel.toString] = label
        
        #if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup.toString] = accessGroup
        }
        #endif
        return query
    }
    
    public init(label: String,
                accessGroup: String? = nil) {
        self.label = label
        self.accessGroup = accessGroup
    }
}
