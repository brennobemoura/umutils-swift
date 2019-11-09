//
//  APIError.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 18/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import Foundation
import ObjectMapper
// swiftlint:disable superfluous_disable_command identifier_name

public struct APIError: Mappable {
    public var code: Int = 0
    public var title: String = ""
    public var messages: [String]?
    
    public var exception: APIException?
    
    public var message: String {
        if code == 401 {
            return "Sua sessão expirou, faça o login novamente."
        }
        if let messages = self.messages {
            return "- " + messages.joined(separator: "\n- ")
        }
        return ""
    }
    
    public init() {}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        self.code = (try? map.value("error.code")) ?? 0
        self.title = (try? map.value("error.message")) ?? ""
        self.messages = try? map.value("error.messages")
        self.exception = try? map.value("exception")
    }
}

public struct MessageError: Swift.Error {
    public let content: String

    public init(content: String) {
        self.content = content
    }
}
