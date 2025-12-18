//
//  PremiereCell.swift
//  CineScope
//
//  Created by Гаухар on 16.12.2025.
//

import UIKit

final class PremiereCell: UICollectionViewCell {

    private let posterImageView = UIImageView()
    private let titleLabel      = UILabel()
    private let ratingLabel     = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
    }

    private func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true

        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2

        ratingLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        ratingLabel.textColor = .systemGreen

        let stack = UIStackView(arrangedSubviews: [posterImageView, titleLabel, ratingLabel])
        stack.axis = .vertical
        stack.spacing = 6

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // постер ~ 70% высоты карточки
            posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
    }

    // MARK: - Public

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = String(format: "⭐️ %.3f", movie.rating)

        if let url = movie.posterURL {
            loadImage(from: url)
        } else if !movie.posterName.isEmpty,
                  let img = UIImage(named: movie.posterName) {
            posterImageView.image = img
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
    }

    // MARK: - Image loading

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.posterImageView.image = image
            }
        }.resume()
    }
}
