//
//  Error+APIError.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

public extension Swift.Error {
    var isSessionExpired: Bool {
        if let moyaError = self as? MoyaError, let response = moyaError.response, response.statusCode == 401 {
            return true
        }
        return false
    }
}

public extension Swift.Error {
    
    var apiError: APIError? {
        do {
            if let moyaError = self as? MoyaError {
                if let response = moyaError.response {
                    return Mapper<APIError>().map(JSONString: try response.mapString())
                } else {
                    var apiError = APIError()
                    if case .underlying((let error, _)) = moyaError {
                        apiError.code = -1
                        apiError.title = error.localizedDescription
                        
                        return apiError
                    } else {
                        apiError.code = -2
                        apiError.title = moyaError.localizedDescription
                    }
                    
                    return apiError
                }
            } else if let mapperError = self as? MapError {
                
                var apiError = APIError()
                var exception = APIException()
                exception.message = mapperError.reason!
                exception.file = String(describing: mapperError.file)
                exception.line = Int(mapperError.line ?? 0)
                exception.type = "MapError"
                
                apiError.exception = exception
                apiError.code = -3
                apiError.title = "Houve um erro ao processar a resposta do servidor. Tente novamente."
                
                return apiError
            }
        } catch {
            print("[APIModel] Error: \(error)")
        }
        return nil
    }
}
