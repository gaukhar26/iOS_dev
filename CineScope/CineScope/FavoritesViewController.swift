//
//  FavoritesViewController.swift
//  CineScope
//
//  Created by Гаухар on 16.12.2025.
//


import UIKit

class FavoritesViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)

    /// Все фильмы, которые подтягиваем из API
    private var allMovies: [Movie] = []

    /// Только те фильмы, что отмечены как избранные
    private var favoriteMovies: [Movie] {
        allMovies.filter { FavoritesManager.shared.isFavorite($0) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Favorites"

        tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )

        setupTableView()
        loadMoviesFromAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // при возврате просто перерисовываем — favoriteMovies считается заново
        tableView.reloadData()
    }

    // MARK: - UI

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate   = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground

        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
    }

    // MARK: - Загрузка фильмов из TMDb

    private func loadMoviesFromAPI() {
        MovieAPI.shared.fetchPopularMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let apiMovies):
                    // APIMovie -> Movie (id берём из TMDb)
                    let mapped = apiMovies.map { Movie(from: $0) }
                    self.allMovies = mapped
                    self.tableView.reloadData()

                case .failure(let error):
                    print("Favorites API error:", error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource / Delegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        favoriteMovies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath
        ) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = favoriteMovies[indexPath.row]
        let detailsVC = MovieDetailsViewController()
        detailsVC.movie = movie
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
