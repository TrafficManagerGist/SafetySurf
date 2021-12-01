import Foundation
import NetworkExtension
import Security

class VPNLogic {
    let vpnManager = NEVPNManager.shared()
    
    private var vpnLoadHandler: (Error?) -> Void { return
        { (error:Error?) in
            if ((error) != nil) {
                print("Could not load VPN Configurations")
                return;
            }
            let protocolIKEv2 = NEVPNProtocolIKEv2()
            let kcs = KeychainService()
            kcs.save(key: "currentPass", value: UserDefaults.standard.string(forKey: "currentPass") ?? "")
            protocolIKEv2.passwordReference = kcs.load(key: "currentPass")
            protocolIKEv2.username = UserDefaults.standard.string(forKey: "currentUsername")
            protocolIKEv2.serverAddress = UserDefaults.standard.string(forKey: "currentIP")
            protocolIKEv2.remoteIdentifier = UserDefaults.standard.string(forKey: "currentID")
            protocolIKEv2.localIdentifier = UserDefaults.standard.string(forKey: "currentID")
            protocolIKEv2.useExtendedAuthentication = true
            protocolIKEv2.disconnectOnSleep = false
            protocolIKEv2.disableMOBIKE = false
            protocolIKEv2.disableRedirect = false
            protocolIKEv2.enableRevocationCheck = false
            protocolIKEv2.useConfigurationAttributeInternalIPSubnet = false
            protocolIKEv2.authenticationMethod = .none
            protocolIKEv2.deadPeerDetectionRate = .medium
            protocolIKEv2.childSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
            protocolIKEv2.childSecurityAssociationParameters.integrityAlgorithm = .SHA384
            protocolIKEv2.childSecurityAssociationParameters.diffieHellmanGroup = .group20
            protocolIKEv2.childSecurityAssociationParameters.lifetimeMinutes = 1440
            protocolIKEv2.ikeSecurityAssociationParameters.encryptionAlgorithm = .algorithmAES256GCM
            protocolIKEv2.ikeSecurityAssociationParameters.integrityAlgorithm = .SHA384
            protocolIKEv2.ikeSecurityAssociationParameters.diffieHellmanGroup = .group20
            protocolIKEv2.ikeSecurityAssociationParameters.lifetimeMinutes = 1440
            self.vpnManager.protocolConfiguration = protocolIKEv2
            self.vpnManager.localizedDescription = "Safety Surf"
            self.vpnManager.isEnabled = true
            self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
        }
    }
    
    private var vpnSaveHandler: (Error?) -> Void { return
        { (error:Error?) in
            if (error != nil) {
                print("Could not save VPN Configurations")
                return
            } else {
                do {
                    try self.vpnManager.connection.startVPNTunnel()
                } catch let error {
                    print("Error starting VPN Connection \(error.localizedDescription)");
                }
            }
        }
    }
    
    public func connectVPN() {
        self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
    }
    
    
    public func disconnectVPN() ->Void {
        vpnManager.connection.stopVPNTunnel()
    }
    
}

// Arguments for the keychain queries
var kSecAttrAccessGroupSwift = NSString(format: kSecClass)
let kSecClassValue = kSecClass as CFString
let kSecAttrAccountValue = kSecAttrAccount as CFString
let kSecValueDataValue = kSecValueData as CFString
let kSecClassGenericPasswordValue = kSecClassGenericPassword as CFString
let kSecAttrServiceValue = kSecAttrService as CFString
let kSecMatchLimitValue = kSecMatchLimit as CFString
let kSecReturnDataValue = kSecReturnData as CFString
let kSecMatchLimitOneValue = kSecMatchLimitOne as CFString
let kSecAttrGenericValue = kSecAttrGeneric as CFString
let kSecAttrAccessibleValue = kSecAttrAccessible as CFString

class KeychainService: NSObject {
    func save(key:String, value:String) {
        let keyData: Data = key.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        let valueData: Data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        let keychainQuery = NSMutableDictionary();
        keychainQuery[kSecClassValue as! NSCopying] = kSecClassGenericPasswordValue
        keychainQuery[kSecAttrGenericValue as! NSCopying] = keyData
        keychainQuery[kSecAttrAccountValue as! NSCopying] = keyData
        keychainQuery[kSecAttrServiceValue as! NSCopying] = "SFTYSRF"
        keychainQuery[kSecAttrAccessibleValue as! NSCopying] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        keychainQuery[kSecValueData as! NSCopying] = valueData;
        SecItemDelete(keychainQuery as CFDictionary)
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    func load(key: String)->Data {
        let keyData: Data = key.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!
        let keychainQuery = NSMutableDictionary();
        keychainQuery[kSecClassValue as! NSCopying] = kSecClassGenericPasswordValue
        keychainQuery[kSecAttrGenericValue as! NSCopying] = keyData
        keychainQuery[kSecAttrAccountValue as! NSCopying] = keyData
        keychainQuery[kSecAttrServiceValue as! NSCopying] = "SFTYSRF"
        keychainQuery[kSecAttrAccessibleValue as! NSCopying] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        keychainQuery[kSecMatchLimit] = kSecMatchLimitOne
        keychainQuery[kSecReturnPersistentRef] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(keychainQuery, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            if let data = result as! NSData? {
                return data as Data;
            }
        }
        return "".data(using: .utf8)!;
    }
}
