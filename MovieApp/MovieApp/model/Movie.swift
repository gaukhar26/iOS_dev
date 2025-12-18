//
//  Movie.swift
//  MovieApp
//
//  Created by ayan on 17.12.2025.
//

import UIKit

// MARK: - Movie Model
struct Movie: Decodable {
    let title: String
    let year: Int
    let imdbID: String
    let rank: Int
    let actors: String
    let aka: String
    let imdbURL: String
    let imdbIV: String
    let poster: String
    let photoWidth: Int
    let photoHeight: Int

    enum CodingKeys: String, CodingKey {
        case title = "#TITLE"
        case year = "#YEAR"
        case imdbID = "#IMDB_ID"
        case rank = "#RANK"
        case actors = "#ACTORS"
        case aka = "#AKA"
        case imdbURL = "#IMDB_URL"
        case imdbIV = "#IMDB_IV"
        case poster = "#IMG_POSTER"
        case photoWidth = "photo_width"
        case photoHeight = "photo_height"
    }
}

// MARK: - Response Model
struct MoviesResponse: Decodable {
    let search: [Movie]

    enum CodingKeys: String, CodingKey {
        case search = "description"
    }
}
