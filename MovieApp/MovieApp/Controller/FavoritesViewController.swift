//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by goha on 17.12.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var favorites: [FavoritesMovie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    func fetchFavorites() {
        favorites = DataManager.shared.fetchFavorites()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell

        let movie = favorites[indexPath.row]
        let movieObj = Movie(
            title: movie.title ?? "no name",
            year: Int(movie.year),
            imdbID: movie.imdbID ?? "Unknown",
            rank: 0,
            actors: movie.actors ?? "Unknown",
            aka: "",
            imdbURL: movie.posterURL ?? "Unknown",
            imdbIV: "",
            poster: movie.posterURL ?? "Unknown",
            photoWidth: 0,
            photoHeight: 0
        )
        
        let isFav = true
        cell.configure(with: movieObj, isFavorite: isFav)
        cell.favoriteButtonTapped = { movie in
            DataManager.shared.removeFavorite(movieID: movie.imdbID)
            self.fetchFavorites()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = favorites[indexPath.row]
        let movieObj = Movie(
            title: movie.title ?? "no name",
            year: Int(movie.year),
            imdbID: movie.imdbID ?? "Unknown",
            rank: 0,
            actors: movie.actors ?? "Unknown",
            aka: "",
            imdbURL: movie.posterURL ?? "Unknown",
            imdbIV: "",
            poster: movie.posterURL ?? "Unknown",
            photoWidth: 0,
            photoHeight: 0
        )
        
        let detailsVC = DetailsViewController()
        detailsVC.movie = movieObj
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
