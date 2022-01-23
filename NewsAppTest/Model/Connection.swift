//
//  Connection.swift
//  NewsAppTest
//
//  Created by Sivaranjani Venkatesh on 22/1/22.
//

import Foundation


class Connection {
    
}


final class APIConnection {
    
    //create singleton for apicaller
    static let shared = APIConnection()
    // create the sturct for constants here i am declared topheadingline url
    
    struct constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=AU&apikey=2341e97683ad47f2a47f8a03b46f585c")
        
    }
    private init() {}
    
    public func getTopStories(completion:@escaping(Result<[Article], Error>) -> Void) {
        guard let url = constants.topHeadLinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            if let error = error {
                completion(.failure(error))
            }
           else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(User.self, from: data)
                    print("Articles:\(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                    
                }
            }
            }
        task.resume()
    }
    
}



struct User: Codable {
    let articles : [Article]
}
struct Article: Codable {
    let source: Source
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
   

        

}
struct Source: Codable {
    let name: String
}

// MARK: - Encode/Decode


func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession Response Handlers


extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    fileprivate func codableTask<T: Codable>(with urlRequest: URLRequest, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func userTask(with url: URL, completionHandler: @escaping (User?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
