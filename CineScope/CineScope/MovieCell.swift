//
//  MovieCell.swift
//  CineScope
//
//  Created by Гаухар on 16.12.2025.
//

import UIKit

class MovieCell: UITableViewCell {
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let ratingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        
        ratingLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        ratingLabel.textColor = .systemOrange
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        cardView.addSubview(posterImageView)
        cardView.addSubview(stack)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            posterImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            posterImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 110),
            
            stack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            stack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.description
        ratingLabel.text = "⭐️ \(movie.rating)"
        
        // сначала пробуем локальный ассет
        if let image = UIImage(named: movie.posterName) {
            posterImageView.image = image
        } else if let url = movie.posterURL {
            // если это URL — грузим из сети
            loadImage(from: url)
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
    }
    
    private func loadImage(from url: URL) {
        // очень простой вариант без кэша — для учебного проекта ок
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
