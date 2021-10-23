//
//  ABRequest.swift
//  Ryanair
//
//  Created by Abraao Nascimento on 21/10/21.
//

import UIKit

class ABRequest: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    private var session: URLSession?
    private var task: URLSessionTask?
    
    typealias CompletionHandler = ((Result<Any>) -> Void)
    private lazy var requestQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "requestQueue"
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    override init() {
        
        super.init()
        
        session = URLSession(configuration: .default,
                             delegate: self,
                             delegateQueue: requestQueue)
        
    }
    
    static func downloadImage(url: URL, completion:@escaping (UIImage?, Data?) -> ()) {
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if error == nil, let data = data {
                completion(UIImage(data: data), data)
            } else {
                completion(nil, nil);
            }
        }
        
        dataTask.resume()
    }
    
    static func makeRequest(url: URL,
                            parameters: [String: Any]? = nil,
                            headers: [String: Any]? = nil,
                            cache: Bool = true) -> URLRequest? {
        
        var request = URLRequest(url: url,
                                 cachePolicy: cache ? .useProtocolCachePolicy : .reloadIgnoringCacheData,
                                 timeoutInterval: 25.0)
        
        // Set Method
        request.httpMethod = "GET"
        
        // Default header
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("ios", forHTTPHeaderField: "client")
        
        let params = makeParams(parameters)
        request.httpBody = params.data(using: .utf8)
        
        return request
    }
    
    func requestObject<T: Codable>(of type: T.Type, request: URLRequest, completion: @escaping CompletionHandler) {
        
        // Make request
        task = session?.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let error = error {
                completion(Result.failure(error: error))
                return
            }
            
            // --- For Debug
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? ""
//            print("URL = \(request.url?.absoluteString ?? "-")")
//            print("ResponseString = \(String(describing: responseString))")
            
            guard let statusCode = response?.getStatusCode(), (200...299).contains(statusCode) else {
                let errorType: ErrorType
                
                switch response?.getStatusCode() {
                case 404:
                    errorType = .notFound
                case 408:
                    errorType = .timeout
                case 400:
                    errorType = .badRequest
                default:
                    errorType = .defaultError
                }
                
                completion(Result.failure(error: errorType))
                return
            }
            
            guard let data = data else {
                completion(Result.failure(error: ErrorType.defaultError))
                return
            }
            
            do {
                let result: T = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(data: result))
            } catch let error {
                completion(Result.failure(error: error))
            }
        })
        
        // Start request
        task?.resume()
        
    }
    
    private static func makeParams(_ parameters: [String: Any]?) -> String {
        
        guard let parameters = parameters else { return "" }
        
        var res = ""
        
        for (name, value) in parameters {
            res += "\(name)=\(Utils.stringfy(value))&"
        }
        
        return String(res.dropLast())
    }
    
    // MARK: - URLSessionDelegate, URLSessionDataDelegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
}

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}

public enum Result<T> {
    case success(data: T)
    case failure(error: Error)
}

public enum ErrorType: Error {
    case urlFail
    case notFound
    case timeout
    case defaultError
    case badRequest
    
    var errorDescription: String? {
        switch self {
        case .urlFail:
            return "Cannot initial URL object."
        case .notFound:
            return "Not Found."
        case .timeout:
            return "Timeout request."
        case .badRequest:
            return "Bad Request."
        case .defaultError:
            return "Something went wrong."
        }
    }
}
