//
//  Result.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation

public enum APIResult<T: Decodable> {
    case success(T)
    case stepSuccess(T)
    case error(Error)
    case undefined
    case empty
}
