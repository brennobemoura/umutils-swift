//
//  Result.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation
import ObjectMapper

public enum APIResult<T: ImmutableMappable> {
    case success(T)
    case stepSuccess(T)
    case error(Error)
    case undefined
    case empty
}
