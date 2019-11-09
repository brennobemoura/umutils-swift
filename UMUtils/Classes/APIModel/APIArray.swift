//
//  APIArray.swift
//  mercadoon
//
//  Created by brennobemoura on 15/08/19.
//  Copyright © 2019 brennobemoura. All rights reserved.
//

import Foundation
import ObjectMapper

open class APIArray<Element: BaseMappable>: ImmutableMappable {
    public let data: [Element]?
    public let meta: [String : Any]?

    required public init(map: Map) throws {
        self.data = try map.value("data")
        self.meta = try? map.value("meta")
    }

    open func mapping(map: Map) {
        self.data >>> map["data"]
        self.meta >>> map["meta"]
    }

    public init(data: [Element]?) {
        self.data = data
        self.meta = nil
    }

    public var page: MetaPage? {
        guard let meta = self.meta else {
            return nil
        }

        return try? .init(JSON: meta)
    }
}
