//
//  DataManager.swift
//  MovieApp
//
//  Created by goha on 17.12.2025.
//
import Foundation
import CoreData
import UIKit

final class DataManager {

    static let shared = DataManager()
    private init() {}

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Create / Add
    func addFavorite(movie: Movie) {
        guard !isFavorite(movieID: movie.imdbID) else { return }

        let favorite = FavoritesMovie(context: context)
        favorite.imdbID = movie.imdbID
        favorite.title = movie.title
        favorite.year = Int16(movie.year)
        favorite.actors = movie.actors
        favorite.posterURL = movie.poster

        saveContext()
    }

    // MARK: - Read / Fetch
    func fetchFavorites() -> [FavoritesMovie] {
        let request: NSFetchRequest<FavoritesMovie> = FavoritesMovie.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Failed to fetch favorites: \(error)")
            return []
        }
    }

    func isFavorite(movieID: String) -> Bool {
        let request: NSFetchRequest<FavoritesMovie> = FavoritesMovie.fetchRequest()
        request.predicate = NSPredicate(format: "imdbID == %@", movieID)
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    // MARK: - Delete / Remove
    func removeFavorite(movieID: String) {
        let request: NSFetchRequest<FavoritesMovie> = FavoritesMovie.fetchRequest()
        request.predicate = NSPredicate(format: "imdbID == %@", movieID)

        if let results = try? context.fetch(request) {
            for object in results {
                context.delete(object)
            }
            saveContext()
        }
    }

    // MARK: - Delete All
    func deleteAllFavorites() {
        let request: NSFetchRequest<FavoritesMovie> = FavoritesMovie.fetchRequest()
        if let results = try? context.fetch(request) {
            for object in results {
                context.delete(object)
            }
            saveContext()
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Failed to save context: \(error)")
            }
        }
    }
}
