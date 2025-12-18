//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by goha on 17.12.2025.
//
import UIKit
import SDWebImage

class DetailsViewController: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()

    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let actorsLabel = UILabel()
    let descriptionLabel = UILabel()

    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupConstraints()
        configure()
    }

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            posterImageView,
            titleLabel,
            infoLabel,
            actorsLabel,
            descriptionLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12
        posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray

        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0

        infoLabel.font = .systemFont(ofSize: 16)
        infoLabel.textColor = .secondaryLabel

        actorsLabel.font = .systemFont(ofSize: 16)
        actorsLabel.numberOfLines = 0

        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
    }

    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Poster
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            posterImageView.heightAnchor.constraint(equalToConstant: 420),

            // Title
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),

            // Info
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // Actors
            actorsLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),
            actorsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            actorsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            // Description
            descriptionLabel.topAnchor.constraint(equalTo: actorsLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    func configure() {
        guard let movie else { return }

        titleLabel.text = movie.title
        infoLabel.text = "Year: \(movie.year)"
        actorsLabel.text = "Actors: \(movie.actors)"
        descriptionLabel.text = "IMDb Rank: \(movie.rank)"

        if let url = URL(string: movie.poster) {
            posterImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder"),
                options: [.retryFailed, .refreshCached]
            )
        }
    }
}
