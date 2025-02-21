//
//  MovieMapper.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/18/25.
//

import Foundation

struct MovieMapper {
    static func toDomain(dto: MovieResponseDTO, type: MovieListType) -> MovieListDomain? {
        let dateFormatter = DateFormatter.movieDate
        
        // 날짜 매핑 (Now Playing의 경우에만)
        let dateRange = type == .nowPlaying && dto.dates != nil ?
            DateRange(
                from: dateFormatter.date(from: dto.dates!.minimum)!,
                to: dateFormatter.date(from: dto.dates!.maximum)!
            ) :
            nil
        
        let movies = dto.results.compactMap { movieDTO -> MovieDomain in
            MovieDomain(
                id: movieDTO.id,
                title: movieDTO.title,
                originalTitle: movieDTO.originalTitle,
                overview: movieDTO.overview,
                posterPath: movieDTO.posterPath,
                backdropPath: movieDTO.backdropPath,
                releaseDate: dateFormatter.date(from: movieDTO.releaseDate),
                rating: movieDTO.voteAverage,
                voteCount: movieDTO.voteCount,
                popularity: movieDTO.popularity,
                genreIds: movieDTO.genreIds,
                originalLanguage: movieDTO.originalLanguage,
                adult: movieDTO.adult,
                video: movieDTO.video
            )
        }
        
        return MovieListDomain(
            movies: movies,
            currentPage: dto.page,
            totalPages: dto.totalPages,
            totalResults: dto.totalResults,
            availableDateRange: dateRange
        )
    }
}

extension MovieMapper {
    static func toDetailDomain(dto: MovieDetailDTO) -> MovieDetailDomain {
           let dateFormatter = DateFormatter.movieDate
           
           return MovieDetailDomain(
               id: dto.id,
               title: dto.title,
               originalTitle: dto.originalTitle,
               overview: dto.overview,
               posterPath: dto.posterPath,
               backdropPath: dto.backdropPath,
               releaseDate: dateFormatter.date(from: dto.releaseDate),
               rating: dto.voteAverage,
               voteCount: dto.voteCount,
               runtime: dto.runtime,
               status: dto.status,
               tagline: dto.tagline,
               popularity: dto.popularity,
               genres: dto.genres.map { GenreDomain(id: $0.id, name: $0.name) },
               productionCompanies: dto.productionCompanies.map {
                   ProductionCompanyDomain(
                       id: $0.id,
                       name: $0.name,
                       logoPath: $0.logoPath,
                       originCountry: $0.originCountry
                   )
               },
               productionCountries: dto.productionCountries.map {
                   ProductionCountryDomain(
                       iso3166_1: $0.iso3166_1,
                       name: $0.name
                   )
               }
           )
       }
}
