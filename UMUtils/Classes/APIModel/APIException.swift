//
//  APIException.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

public struct APIException: Decodable {
    
    public let line: Int
    public let severity: String
    public let type: String
    public let file: String
    public let message: String
    
    public let trace: [String]?
    
    public init(line: Int, severity: String, type: String, file: String, message: String, trace: [String]?) {
        self.line = line
        self.severity = severity
        self.type = type
        self.file = file
        self.message = message
        self.trace = trace
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.line = (try? container.decode(.line)) ?? 0
        self.message = (try? container.decode(.message)) ?? ""
        self.severity = (try? container.decode(.severity)) ?? ""
        self.type = (try? container.decode(.type)) ?? ""
        self.file = (try? container.decode(.file)) ?? ""
        self.trace = try? container.decode(.trace)
    }
}

extension APIException {
    enum CodingKeys: String, CodingKey {
        case line
        case severity
        case type
        case file
        case message
        case trace
    }
}
