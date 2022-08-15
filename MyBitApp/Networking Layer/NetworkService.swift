//
//  NetworkService.swift
//  MyBitApp
//
//  Created by admin on 14.08.2022.
//

import UIKit

struct Constants {
    static let urlForPosts = "https://my-json-server.typicode.com/typicode/demo/posts"
    static let urlForComments = "https://my-json-server.typicode.com/typicode/demo/comments"
}

enum DataType {
    case post
    case comment
}

class NetworkService {
    private let coreData = CoreDataService.shared
    var delegate: UIViewController?
    func loadJson(with dataType: DataType) {
        var url = ""
        switch dataType {
        case .post:
            url = Constants.urlForPosts
        default:
            url = Constants.urlForComments
        }
        loadJson(fromURLString: url) { (result) in
            switch result {
            case .success(let data):
                self.parseData(jsonData: data)
            case .failure(_):
                break
            }
        }
    }

    private func parseData(jsonData: Data) {
        do {
            guard let decodedData = try? JSONDecoder().decode([PostModel].self,
                                                         from: jsonData) else {
                let decodedData =  try JSONDecoder().decode([CommentModel].self,
                                                             from: jsonData)
                for data in decodedData {
                    coreData.saveComment(newElement: data)
                }
                return
            }
            for data in decodedData {
                coreData.savePost(newElement: data)
            }
        } catch { }
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }

                if let data = data {
                    completion(.success(data))
                }
            }
            urlSession.resume()
        }
    }
}
