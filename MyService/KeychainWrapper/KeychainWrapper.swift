//
//  KeychainWrapper.swift
//  MyService
//
//  Created by Hsiao, Wayne on 2019/9/27.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import Foundation
import Security

public typealias KeychainWrapperAdoptor = KeychainItemQueryable & KeychainItemStorable

public struct KeychainWrapper {
    
    var searchable: KeychainWrapperAdoptor
    
    public init(searchable: KeychainWrapperAdoptor) {
        self.searchable = searchable
    }
    
    public func setRef(_ ref: String) throws {
        
    }

    /// Set value
    /// - Parameter value: Value like to be stored into keychain.
    /// - Parameter account: Used to identifier the item.
    /// - Parameter accessControl:
    ///                 1) When unlocked - kSecAttrAccessibleWhenUnlocked,
    ///                 2) While locked - N/A,
    ///                 3) After first unlock - kSecAttrAccessibleAfterFirstUnlock,
    ///                 4) Always - kSecAttrAccessibleAlways,
    ///                 5) Passcode enabled - kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
    /// */
    public func setValue(_ value: String,
                         forAccount account: String,
                         accessControl: SecAccessControl? = nil) throws {
        
        do {
            guard let encodedData = value.data(using: .utf8) else {
                throw WrapperError.stringToDataError
            }
            
            let query = try searchable.addquery(value, account: account, accessControl: nil)
            
            var status = SecItemCopyMatching(query.toCFDictionary, nil)
            
            switch status {
            case errSecSuccess:
                var attributesToUpdate = [String: Any]()
                attributesToUpdate[kSecValueData.toString] = encodedData
                status = SecItemUpdate(query.toCFDictionary,
                                       attributesToUpdate.toCFDictionary)
                if status != errSecSuccess {
                    throw WrapperError.error(from: status)
                }
            case errSecItemNotFound:
//                query[kSecValueData.toString] = encodedData
                status = SecItemAdd(query.toCFDictionary, nil)
                if status != errSecSuccess {
                    throw WrapperError.failed
                }
            default:
                throw WrapperError.failed
            }
        } catch {
            throw error
        }
    }
    
    /// Retrieve value of specific account from keychain
    /// - Parameter account: Name of the account.
    public func getValue(for account: String) throws -> String? {
        var query = searchable.getquery
        query[kSecMatchLimit.toString] = kSecMatchLimitOne
        query[kSecReturnAttributes.toString] = kCFBooleanTrue
        query[kSecReturnData.toString] = kCFBooleanTrue
        query[kSecAttrAccount.toString] = account
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query.toCFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            guard let queriedItem = queryResult as? [String: Any],
                let data = queriedItem[kSecValueData.toString] as? Data,
                let password = String(data: data, encoding: .utf8) else {
                    throw WrapperError.dataToStringError
            }
            return password
        case errSecItemNotFound:
            return nil
        default:
            throw WrapperError.error(from: status)
        }
    }
    
    
    /// Remove items of specific account.
    /// - Parameter account: Name of the account.
    public func remove(for account: String) throws {
        var query = searchable.getquery
        query[kSecAttrAccount.toString] = account
        
        let status = SecItemDelete(query.toCFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw WrapperError.error(from: status)
        }
    }
    
    /// Clear all items in the keychain.
    public func removeAll() throws {
        let status = SecItemDelete(searchable.getquery.toCFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw WrapperError.error(from: status)
        }
    }
}
