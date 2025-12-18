//
//  FavoritesManager.swift
//  CineScope
//
//  Created by Гаухар on 17.12.2025.
//

import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()

    private let storageKey = "favorites_movie_ids"
    private var favoriteIDs: Set<Int> = []

    private init() {
        let ids = UserDefaults.standard.array(forKey: storageKey) as? [Int] ?? []
        favoriteIDs = Set(ids)
    }

    private func save() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: storageKey)
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteIDs.contains(movie.id)
    }

    @discardableResult
    func toggleFavorite(_ movie: Movie) -> Bool {
        if favoriteIDs.contains(movie.id) {
            favoriteIDs.remove(movie.id)
            save()
            return false
        } else {
            favoriteIDs.insert(movie.id)
            save()
            return true
        }
    }

    func allFavoriteIDs() -> [Int] {
        Array(favoriteIDs)
    }
}
