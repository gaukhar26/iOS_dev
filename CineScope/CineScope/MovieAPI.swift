//
//  MovieAPI.swift
//  CineScope
//
//  Created by Гаухар on 18.12.2025.
//

import Foundation

final class MovieAPI {

    static let shared = MovieAPI()
    private init() {}

    private let apiKey  = "79c5aee690bfa24906c7f9167d278d17"
    private let baseURL = "https://api.themoviedb.org/3"

    // MARK: - Popular

    func fetchPopularMovies(completion: @escaping (Result<[TMDBMovie], Error>) -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Search

    func searchMovies(query: String,
                      completion: @escaping (Result<[TMDBMovie], Error>) -> Void) {

        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            completion(.success([]))
            return
        }

        let encoded = trimmed.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? ""

        let urlString =
        "\(baseURL)/search/movie?api_key=\(apiKey)&language=en-US&query=\(encoded)&page=1&include_adult=false"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(TMDBMoviesResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
