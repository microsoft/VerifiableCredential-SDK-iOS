import VCCrypto

public struct VCSDKConfiguration: VCSDKConfigurable {
    
    public static var sharedInstance = VCSDKConfiguration()
    
    public private(set) var accessGroupIdentifier: String?
    
    public private(set) var discoveryUrl: String?
    
    private init() {}
    
    public mutating func setAccessGroupIdentifier(with id: String) {
        self.accessGroupIdentifier = id
    }
    
    public mutating func setDiscoveryUrl(with url: String) {
        self.discoveryUrl = url
    }
}
