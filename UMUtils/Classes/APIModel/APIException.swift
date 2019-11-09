//
//  APIException.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation
import ObjectMapper

public struct APIException: Mappable {
    
    public var line: Int! = 0
    public var severity: String = ""
    public var type: String = ""
    public var file: String = ""
    public var message: String = ""
    
    public var trace: [AnyObject]?
    
    public init() {}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        self.line = (try? map.value("line")) ?? 0
        self.message = (try? map.value("message")) ?? ""
        self.severity = (try? map.value("severity")) ?? ""
        self.type = (try? map.value("type")) ?? ""
        self.file = (try? map.value("file")) ?? ""
        self.trace = try? map.value("trace")
    }
}
