//
//  Movie.swift
//  CineScope
//
//  Created by Гаухар on 16.12.2025.
//

import Foundation

// MARK: - Основная модель фильма

struct Movie: Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let posterName: String      // имя локального ассета (может быть пустым)
    let posterURL: URL?         // постер из сети (TMDb)
    let rating: Double
    let year: Int
    let genre: String
    let trailerQuery: String    // строка для поиска трейлера на YouTube

    /// ⭐️ ИНИТ, КОТОРЫЙ ПОВТОРЯЕТ СТАРЫЙ ВАРИАНТ
    /// Используется в Favorites/Search, где ты руками создаёшь фильмы.
    init(
        id: Int,
        title: String,
        description: String,
        posterName: String,
        rating: Double,
        year: Int,
        genre: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.posterName = posterName
        self.posterURL = nil              // для локальных фильмов URL нет
        self.rating = rating
        self.year = year
        self.genre = genre
        self.trailerQuery = "\(title) trailer"
    }
}

// MARK: - TMDb модели

struct TMDBMoviesResponse: Decodable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
    let vote_average: Double
    let release_date: String?
    let genre_ids: [Int]?
}

// простой маппинг genre_id → название
private func genreName(from id: Int?) -> String {
    guard let id = id else { return "Unknown" }

    switch id {
    case 28: return "Action"
    case 12: return "Adventure"
    case 16: return "Animation"
    case 35: return "Comedy"
    case 18: return "Drama"
    case 27: return "Horror"
    case 10749: return "Romance"
    case 878: return "Sci-Fi"
    default: return "Other"
    }
}

// MARK: - Маппинг TMDb → Movie

extension Movie {
    init(from api: TMDBMovie) {
        // год из release_date ("2010-07-16" → 2010)
        let year: Int
        if let date = api.release_date,
           let first = date.split(separator: "-").first,
           let y = Int(first) {
            year = y
        } else {
            year = 0
        }

        // постер
        let basePosterURL = "https://image.tmdb.org/t/p/w500"
        let url: URL?
        if let path = api.poster_path {
            url = URL(string: basePosterURL + path)
        } else {
            url = nil
        }

        self.id = api.id
        self.title = api.title
        self.description = api.overview
        self.posterName = ""                 // локального ассета нет
        self.posterURL = url
        self.rating = api.vote_average
        self.year = year
        self.genre = genreName(from: api.genre_ids?.first)
        self.trailerQuery = "\(api.title) trailer"
    }
}
