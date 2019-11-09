//
//  Moya+ObjectMapper.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 17/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

public extension Response {
    
    func mapApi<T: ImmutableMappable>(_ mappableType: T.Type) -> APIResult<T> {
        if self.statusCode == 204 {
            return APIResult.empty
        }
        
        do {
            return APIResult.success(try Mapper<T>().map(JSONString: mapString()))
        } catch {
            print("[APIModel] error \(error)")
            return APIResult.error(error)
        }
    }
}
