//
//  CountryManager.swift
//  WalmartCountries
//
//  Created by Sha'Marcus Walker on 3/14/25.
//

import Foundation

protocol NetworkProtocol {
    func fetchData<Response>(endpoint: CountryEndpoints<Response>, useCache: Bool) async throws -> Response
}

class CountryManager: NetworkProtocol {
  
    private let jsonDecoder: JSONDecoder
    private let urlCache: URLCache
    
    init(jsonDecoder: JSONDecoder = JSONDecoder(), urlCache: URLCache = URLCache.shared) {
        self.jsonDecoder = jsonDecoder
        self.urlCache = urlCache
    }
    
    func fetchData<Response>(endpoint: CountryEndpoints<Response>, useCache: Bool) async throws -> Response where Response : Decodable {
        
        let urlRequest = URLRequest(url: endpoint.url)
        
        if useCache, let cachedResponse = urlCache.cachedResponse(for: urlRequest) {
            print("Fetched cached response for \(endpoint.url)")
            return try jsonDecoder.decode(Response.self, from: cachedResponse.data)
        }
        
        let (data, response) = try await URLSession.shared.data(from: endpoint.url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard(200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        if useCache {
            let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
            urlCache.storeCachedResponse(cachedResponse, for: URLRequest(url: endpoint.url))
            print("Stored response in cache for \(endpoint.url)")
        }
                
        return try jsonDecoder.decode(Response.self, from: data)
            
    }
    
}
