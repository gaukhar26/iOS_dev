//
//  SearchViewController.swift
//  MovieApp
//
//  Created by ayan on 17.12.2025.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Search movies"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
    }

    func searchMovies(query: String) {
        print("🔍 Search started: \(query)")

        Services.shared.searchMovies(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    print("✅ Found movies: \(movies.count)")
                    self?.movies = movies
                    self?.tableView.reloadData()

                case .failure(let error):
                    print("❌ Search error: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "searchCell",
            for: indexPath
        ) as! SearchTableViewCell

        let movie = movies[indexPath.row]
        cell.configure(with: movie, isFavorite: false)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = movies[indexPath.row]

        let detailsVC = DetailsViewController()
        detailsVC.movie = movie

        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.resignFirstResponder()
        searchMovies(query: text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            movies.removeAll()
            tableView.reloadData()
        }
    }
}
