//
//  MovieDetailsViewController.swift
//  CineScope
//
//  Created by Гаухар on 16.12.2025.
//

import UIKit
import SafariServices

class MovieDetailsViewController: UIViewController {

    // фильм, который показываем
    var movie: Movie?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let watchTrailerButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = movie?.title ?? "Details"

        setupUI()
        configureWithMovie()
    }

    // MARK: - UI

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 16

        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 2

        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        infoLabel.textColor = .secondaryLabel

        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0

        // Watch trailer
        watchTrailerButton.setTitle("Watch trailer", for: .normal)
        watchTrailerButton.backgroundColor = .systemBlue
        watchTrailerButton.setTitleColor(.white, for: .normal)
        watchTrailerButton.layer.cornerRadius = 12
        watchTrailerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        watchTrailerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        watchTrailerButton.addTarget(self, action: #selector(watchTrailerTapped), for: .touchUpInside)

        // Favorites button (цвет зададим в updateFavoriteButton)
        favoriteButton.layer.cornerRadius = 12
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        favoriteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            posterImageView,
            titleLabel,
            infoLabel,
            descriptionLabel,
            watchTrailerButton,
            favoriteButton
        ])
        stack.axis = .vertical
        stack.spacing = 12

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.heightAnchor
                .constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func configureWithMovie() {
        guard let movie = movie else { return }

        // 1. Пытаемся загрузить постер по URL из API
        if let url = movie.posterURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard
                    let self = self,
                    let data = data,
                    let image = UIImage(data: data)
                else { return }

                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            }.resume()

        // 2. Если URL нет — пробуем локальный ассет
        } else if !movie.posterName.isEmpty,
                  let image = UIImage(named: movie.posterName) {
            posterImageView.image = image

        // 3. Фолбэк – системная иконка
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }

        titleLabel.text = movie.title
        infoLabel.text = "\(movie.year) • \(movie.genre) • ⭐️ \(movie.rating)"
        descriptionLabel.text = movie.description

        updateFavoriteButton()
    }


    // MARK: - Favorites UI

    private func updateFavoriteButton() {
        guard let movie = movie else { return }
        let isFav = FavoritesManager.shared.isFavorite(movie)

        if isFav {
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
            favoriteButton.backgroundColor = .systemRed
        } else {
            favoriteButton.setTitle("Add to Favorites", for: .normal)
            favoriteButton.backgroundColor = .systemGreen
        }

        favoriteButton.setTitleColor(.white, for: .normal)
    }

    // MARK: - Actions

    @objc private func watchTrailerTapped() {
        guard let movie = movie else { return }
        openTrailer(for: movie)
    }

    private func openTrailer(for movie: Movie) {
        // пока просто поиск на YouTube
        let query = "\(movie.title) trailer"
        guard
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://www.youtube.com/results?search_query=\(encoded)")
        else { return }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @objc private func favoriteTapped() {
        guard let movie = movie else { return }
        _ = FavoritesManager.shared.toggleFavorite(movie)
        updateFavoriteButton()
    }
}

