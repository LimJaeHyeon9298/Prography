//
//  MovieMapper.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import Foundation

struct MovieMapper {
    static func toDomain(dto:MovieDTO) -> MovieDomain? {
        guard let releaseDate = DateFormatter.movieDate.date(from: dto.releaseDate) else {return nil}
        
        return MovieDomain(id: dto.id,
                           title: dto.title,
                           overview: dto.overview,
                           posterURL: dto.posterPath.flatMap {URL(string: "https://image.tmdb.org/t/p/w500/\($0)")},
                           releaseDate: releaseDate,
                           rating: dto.voteAverage,
                           genreIds: dto.genreIds )
        
    }
    
    static func toDomain(dto: MovieResponseDTO) -> MovieListDomain? {
            let dateFormatter = DateFormatter.movieDate
            
            guard let fromDate = dateFormatter.date(from: dto.dates.minimum),
                  let toDate = dateFormatter.date(from: dto.dates.maximum),
                  let movies = dto.results.compactMap(toDomain) as [MovieDomain]? else {
                return nil
            }
            
            return MovieListDomain(
                movies: movies,
                currentPage: dto.page,
                totalPages: dto.totalPages,
                availableDateRange: DateRange(from: fromDate, to: toDate)
            )
        }
}

extension MovieMapper {
    static func toDomain(dto: PopularMovieResponseDTO) -> PopularMovieListDomain? {
        guard let movies = dto.results.compactMap(toDomain) as [MovieDomain]? else {
            return nil
        }
        
        return PopularMovieListDomain(
            movies: movies,
            currentPage: dto.page,
            totalPages: dto.totalPages
        )
    }
}

extension MovieMapper {
    static func toDomain(dto: TopRatedMovieDTO) -> TopRatedMovieDomain? {
        return TopRatedMovieDomain(
            id: dto.id,
            title: dto.title,
            originalTitle: dto.originalTitle,
            overview: dto.overview,
            posterPath: dto.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500/\($0)") }?.absoluteString,
            backdropPath: dto.backdropPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500/\($0)") }?.absoluteString,
            releaseDate: dto.releaseDate,
            voteAverage: dto.voteAverage,
            voteCount: dto.voteCount,
            popularity: dto.popularity,
            genreIds: dto.genreIds,
            originalLanguage: dto.originalLanguage,
            adult: dto.adult,
            video: dto.video
        )
    }
    
    static func toDomain(dto: TopRatedMovieResponseDTO) -> TopRatedMovieListDomain? {
        guard let movies = dto.results.compactMap(toDomain) as [TopRatedMovieDomain]? else {
            return nil
        }
        
        return TopRatedMovieListDomain(
            page: dto.page,
            movies: movies,
            totalPages: dto.totalPages,
            totalResults: dto.totalResults
        )
    }
    
    static func toDomain(dto: MovieDetailDTO) -> MovieDetailDomain {
        return MovieDetailDomain(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterURL: dto.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500/\($0)") },
            rating: dto.voteAverage,
            genres: dto.genres.map { $0.name}
        )
    }
}
