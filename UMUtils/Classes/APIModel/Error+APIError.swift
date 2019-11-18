//
//  Error+APIError.swift
//  TokBeauty
//
//  Created by brennobemoura on 09/08/19.
//  Copyright © 2019 TokBeauty. All rights reserved.
//

import Foundation
import Moya

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
                    return try JSONDecoder().decode(APIError.self, from: response.data)
                } else {
                    if case .underlying((let error, _)) = moyaError {
                        return APIError(
                            code: -1,
                            title: error.localizedDescription
                        )
                    }

                    return APIError(
                        code: -2,
                        title: moyaError.localizedDescription
                    )
                }

            } else if let decodingError = self as? DecodingError {

                return APIError(
                    code: -3,
                    title: "Houve um erro ao processar a resposta do servidor. Tente novamente.",
                    exception: .init(
                        line: 0,
                        severity: "",
                        type: "DecodingError",
                        file: decodingError.helpAnchor ?? "nil",
                        message: decodingError.failureReason ?? "nil",
                        trace: nil
                ))
           }
        } catch {
            print("[APIModel] Error: \(error)")
        }
        return nil
    }
}
