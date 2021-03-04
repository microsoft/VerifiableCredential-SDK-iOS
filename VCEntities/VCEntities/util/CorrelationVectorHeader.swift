//
//  Copyright (C) Microsoft Corporation. All rights reserved.
//

public struct CorrelationVectorHeader {
    
    private var name: String
    private var value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    public mutating func setCorrelationVector(_ cv: String) {
        value = cv
    }
    
    public func getName() -> String? {
        
        if name == "" {
            return nil
        }
        
        return name
    }
    
    public func getCorrelationVector() -> String? {
        
        if value == "" {
            return nil
        }
        
        return value
    }
}
