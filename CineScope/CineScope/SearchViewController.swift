//
//  SearchViewController.swift
//  CineScope
//
//  Created by Гаухар on 16.12.2025.
//


import UIKit

class SearchViewController: UIViewController {

    private let searchField = UITextField()
    private let tableView   = UITableView(frame: .zero, style: .plain)

    // Результаты поиска (уже в твоей модели Movie)
    private var results: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"

        tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )

        setupSearchField()
        setupTableView()
    }

    // MARK: - UI

    private func setupSearchField() {
        searchField.placeholder = "Search movies"
        searchField.backgroundColor = .systemGray6
        searchField.layer.cornerRadius = 16
        searchField.clearButtonMode = .whileEditing
        searchField.returnKeyType = .search

        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .secondaryLabel
        icon.contentMode = .center
        icon.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        searchField.leftView = icon
        searchField.leftViewMode = .always

        searchField.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8),
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

    // MARK: - Search logic

    @objc private func textChanged() {
        let text = searchField.text ?? ""
        let trimmed = text.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            results = []
            tableView.reloadData()
            return
        }

        searchMovies(query: trimmed)
    }

    private func searchMovies(query: String) {
        MovieAPI.shared.searchMovies(query: query) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let apiMovies):
                    self.results = apiMovies.map { Movie(from: $0) }
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Search error:", error.localizedDescription)
                    self.results = []
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - TableView

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath
        ) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = results[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = results[indexPath.row]
        let detailsVC = MovieDetailsViewController()
        detailsVC.movie = movie
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
