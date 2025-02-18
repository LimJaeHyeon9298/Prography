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
                           rating: dto.voteAverage)
        
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
