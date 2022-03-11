//
//  WebService.swift
//  HotCoffee
//
//  Created by Erkan Kızgın on 5.03.2022.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod:String {
    case get = "GET"
    case post = "POST"
}

struct Resource<T: Codable> {
    let url : URL
    var httpMethod: HttpMethod = .get
    var body: Data?
}

extension Resource {
    init(url:URL){
        self.url = url
    }
}

class Websevice {
    
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T,NetworkError>) -> Void) {
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(resource.httpMethod.rawValue)
        
        URLSession.shared.dataTask(with: request){
            data,response,error in
            
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            
            /*do {
                let result = try JSONDecoder().decode(T.self, from: data)
            } catch  {
                print(error)
            }*/
            let result = try? JSONDecoder().decode(T.self, from: data)
            
            if let result = result {
                DispatchQueue.main.async{
                    completion(.success(result))
                }
            }else{
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
}
