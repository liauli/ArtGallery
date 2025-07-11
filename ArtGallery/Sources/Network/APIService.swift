//
//  APIService.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 19/05/25.
//

import Combine
import Foundation

enum ApiError: Error {
    case wrongPath
    case failToDecode
}

/// @mockable
protocol APIService {
    func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error>
    func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error>
}

class APIServiceImpl: APIService {
    private let baseApi = "https://api.artic.edu/api/v1/artworks"
    private let apiLimit = "limit=\(ApiConstant.ApiLimit)"
    private let urlSession: URLSession
    
    init(_ urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func fetchGalleryItems(_ page: Int) -> AnyPublisher<GalleryResponse, Error> {
        guard let url = URL(string: "\(baseApi)?\(apiLimit)&fields=\(ApiConstant.apiFields.joined(separator: ","))&page=\(page)") else {
            
            return Fail(error: ApiError.wrongPath).eraseToAnyPublisher()
        }
        print("==== init \(url.absoluteString)")
        return createPublisher(url)
    }
    
    func searchGallery(_ query: String, _ page: Int) -> AnyPublisher<GalleryResponse, Error> {
        guard let url = URL(string: "\(baseApi)?q=\(query)&fields=\(ApiConstant.apiFields.joined(separator: ","))&\(apiLimit)&page=\(page)") else {
            
            return Fail(error: ApiError.wrongPath).eraseToAnyPublisher()
        }
        print("==== \(url.absoluteString)")
        return createPublisher(url)
    }
    
    private func createPublisher(_ url: URL) -> AnyPublisher<GalleryResponse, Error> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GalleryResponse.self, decoder: decoder)
            .mapError { error in
                return ApiError.failToDecode
            }
            .eraseToAnyPublisher()
    }
}
