//
//  MovieCacheManager.swift
//  Prography_assignment
//
//  Created by 임재현 on 3/2/25.
//

import Foundation

// 캐시 키 구조체
struct MovieCacheKey: Hashable {
    let type: MovieListType
    let page: Int
}

// 영화 데이터 캐시 매니저
class MovieCacheManager {
    static let shared = MovieCacheManager()
    private var cache: [MovieCacheKey: MovieListDomain] = [:]
    private var expirationTimes: [MovieCacheKey: Date] = [:]
    private let cacheLifetime: TimeInterval = 60 * 10 // 10분 캐시
    
    func getMovie(type: MovieListType, page: Int) -> MovieListDomain? {
        let key = MovieCacheKey(type: type, page: page)
        
        // 만료된 캐시인지 확인
        if let expirationTime = expirationTimes[key], expirationTime < Date() {
            cache.removeValue(forKey: key)
            expirationTimes.removeValue(forKey: key)
            return nil
        }
        
        return cache[key]
    }
    
    func saveMovie(type: MovieListType, page: Int, data: MovieListDomain) {
        let key = MovieCacheKey(type: type, page: page)
        cache[key] = data
        expirationTimes[key] = Date().addingTimeInterval(cacheLifetime)
    }
    
    func clearCache() {
        cache.removeAll()
        expirationTimes.removeAll()
    }
}
