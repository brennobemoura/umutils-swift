//
//  APIError.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 18/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import Foundation
// swiftlint:disable superfluous_disable_command identifier_name

public struct APIError: Decodable {
    private let error: Error

    public var code: Int {
        return self.error.code
    }

    public var title: String {
        return self.error.message
    }

    public var messages: [String]? {
        return self.error.messages
    }
    
    public let exception: APIException?
    
    public var message: String {
        if code == 401 {
            return "Sua sessão expirou, faça o login novamente."
        }
        if let messages = self.messages {
            return "- " + messages.joined(separator: "\n- ")
        }
        return ""
    }
    
    public init(code: Int, title: String, messages: [String]? = nil, exception: APIException? = nil) {
        self.error = .init(code: code, message: title, messages: messages)
        self.exception = exception
    }
}

extension APIError {
    enum CodingKeys: String, CodingKey {
        case error
        case exception
    }
}

extension APIError {
    private struct Error: Codable {
        let code: Int
        let message: String
        let messages: [String]?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.code = (try? container.decode(.code)) ?? 0
            self.message = (try? container.decode(.message)) ?? ""
            self.messages = try? container.decode(.messages)
        }

        init(code: Int, message: String, messages: [String]?) {
            self.code = code
            self.message = message
            self.messages = messages
        }

        enum CodingKeys: String, CodingKey {
            case code
            case message
            case messages
        }
    }
}

public struct MessageError: Swift.Error {
    public let content: String

    public init(content: String) {
        self.content = content
    }
}
