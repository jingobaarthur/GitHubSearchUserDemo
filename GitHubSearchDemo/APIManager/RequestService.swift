//
//  RequestService.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class RequestService{
    
    private enum APIError: Error{
        
        case responseError
        case limitPageError
        case domainError
        case notModified
        case unprocessableEntity
        case serviceUnavailable
        
        var errorMessage: String{
            switch self{
            case.responseError:
                return "Response Error"
            case .limitPageError:
                return "Github API rate limit exceeded. Wait for 60 seconds and try again"
            case .domainError:
                return "Domain Error"
            case .notModified:
                return "Not Modified"
            case .unprocessableEntity:
                return "Unprocessable Entity"
            case .serviceUnavailable:
                return "Service Unavailable"
            }
        }
    }
    
    enum APIRouter{
        static let baseUrl = "https://api.github.com/"
        case searchUser
        var path: String{
            switch self{
            case .searchUser:
                return APIRouter.baseUrl + "search/users"
            }
        }
    }
    private lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 6
        let manger = Session(configuration: configuration)
        //manger.adapter = CustomAdapter()
        return manger
    }()
}
extension RequestService{
    ///delete
    func deleteRequest<T:Codable>(path: String,
                                  parameter: Parameters? = nil,
                                  resultType:T.Type,
                                  method:HTTPMethod = .delete,
                                  encoding: ParameterEncoding = URLEncoding.default) -> Single<T>{
        return singleRequest(path: path, parameter: parameter, resultType: resultType, method: .delete, encoding: encoding)
    }
    ///patch
    func patchRequest<T:Codable>(path: String,
                                 parameter: Parameters? = nil,
                                 resultType:T.Type,
                                 method:HTTPMethod = .patch,
                                 encoding: ParameterEncoding = URLEncoding.default) -> Single<T>{
        return singleRequest(path: path, parameter: parameter, resultType: resultType, method: .patch, encoding: encoding)
    }
    ///post
    func postRequest<T:Codable>(path: String,
                                parameter: Parameters? = nil,
                                resultType:T.Type,
                                method:HTTPMethod = .post,
                                encoding: ParameterEncoding = URLEncoding.default) -> Single<T>{
        return singleRequest(path: path, parameter: parameter, resultType: resultType, method: .post, encoding: encoding)
    }
    ///get
    func getRequest<T:Codable>(path: String,
                               parameter: Parameters? = nil,
                               resultType:T.Type,
                               method:HTTPMethod = .get,
                               encoding: ParameterEncoding = URLEncoding.default) -> Single<T>{
        return singleRequest(path: path, parameter: parameter, resultType: resultType, method: .get, encoding: encoding)
    }
    ///put
    func putRequest<T:Codable>(path: String,
                               parameter: Parameters? = nil,
                               resultType:T.Type,
                               method:HTTPMethod = .put,
                               encoding: ParameterEncoding = URLEncoding.default) -> Single<T>{
        return singleRequest(path: path, parameter: parameter, resultType: resultType, method: .put, encoding: encoding)
    }
    func singleRequest<T:Codable>(path: String,
                                  parameter: Parameters? = nil,
                                  resultType:T.Type,
                                  method:HTTPMethod,
                                  encoding: ParameterEncoding = URLEncoding.default)-> Single<T>{

        let para = self.transPara(parameters: parameter)
        
        print("API URL: \(path), \nParameters: \(para), \nMethod: \(method)")
        
        return Single<T>.create { observer in
            
            let task = self.sessionManager.request(path, method: method, parameters: para, encoding: encoding).responseJSON { (response) in
                
                if let error = response.error{
                    observer(.error(error))
                    return
                }
                
                if let statusCode = response.response?.statusCode, (statusCode < 200 || statusCode > 300){
                    if statusCode == 304{
                        observer(.error(APIError.notModified))
                    }else if statusCode == 422{
                        observer(.error(APIError.unprocessableEntity))
                    }else if statusCode == 503{
                        observer(.error(APIError.serviceUnavailable))
                    }else if statusCode == 404{
                        observer(.error(APIError.domainError))
                    }
                    else{
                        observer(.error(APIError.responseError))
                    }
                    return
                }
                
                guard let data = response.data else {return}
                do{
                    let result = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(result))
                }catch let jsonError{
                    observer(.error(jsonError))
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    func transPara(parameters : Parameters? , modify:Bool = true) -> Parameters
    {
        var newParameters: Parameters = [String: Any]()
        if let data = parameters
        {
            for name in data.keys {
                newParameters[name] = data[name]
            }
            
        }
        if modify == true
        {
            
        }
        
        return newParameters
        
    }
}
