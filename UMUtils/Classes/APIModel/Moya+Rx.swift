//
//  Moya+Observable.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 14/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import Moya
import ObjectMapper
import RxSwift
import RxCocoa

public extension ObservableType where E == Moya.Response {
    
    func map<T: ImmutableMappable>(_ mappableType: T.Type) -> Observable<APIResult<T>> {
        return flatMap { response -> Observable<APIResult<T>> in
            return Observable.just(response.mapApi(mappableType))
            }.do(onError: { error in
                if error is MapError {
                    print("[APIModel] error \(error)")
                }
            })
    }
    
    // MARK: Map to Driver
    
    func mapDriver<T: ImmutableMappable>(_ mappableType: T.Type) -> Driver<APIResult<T>> {
        return map(mappableType).asDriver(onErrorRecover: { (error) -> Driver<APIResult<T>> in
            return Driver.just(APIResult.error(error))
        })
    }
}
