//
//  APIManager.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import Foundation
import RxSwift
import Alamofire

class APIManager: NSObject{
    
    static let share: APIManager = APIManager()
    private override init() {}
    static let requestServer = RequestService()

    func fetchSearchUserData(q: String, page: Int) -> Single<SearchUserResult>{
        let parameters: Parameters = ["q": q, "page": page]
        return APIManager.requestServer.getRequest(path: RequestService.APIRouter.searchUser.path, parameter: parameters, resultType: SearchUserResult.self).map {
            return $0
        }
    }
}
