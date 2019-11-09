//
//  Object.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation
import ObjectMapper

open class APIObject<Object: BaseMappable>: ImmutableMappable {
    public let data: Object?

    public required init(map: Map) throws {
        self.data = try map.value("data")
    }

    open func mapping(map: Map) {
        self.data >>> map["data"]
    }

    public init(data: Object?) {
        self.data = data
    }
}
