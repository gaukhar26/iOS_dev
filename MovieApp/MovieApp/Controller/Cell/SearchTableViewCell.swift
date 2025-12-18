//
//  SearchTableViewCell.swift
//  MovieApp
//
//  Created by ayan on 16.12.2025.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var imagePoster: UIImageView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favoritesButton: UIButton!

    var favoriteButtonTapped: ((Movie) -> Void)?
    
    var currentMovie: Movie?
    var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePoster.image = UIImage(named: "placeholder")
        imagePoster.contentMode = .scaleAspectFill
        imagePoster.clipsToBounds = true
        imagePoster.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        favoritesButton.addTarget(self, action: #selector(favoritesButtonAction), for: .touchUpInside)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imagePoster.sd_cancelCurrentImageLoad()
        imagePoster.image = UIImage(named: "placeholder")
        titleLabel.text = nil
        ratingLabel.text = nil
        favoritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        currentMovie = nil
        isFavorite = false
    }

    func configure(with movie: Movie, isFavorite: Bool) {
        self.currentMovie = movie
        self.isFavorite = isFavorite
        
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.rank)"

        let starName = isFavorite ? "star.fill" : "star"
        favoritesButton.setImage(UIImage(systemName: starName), for: .normal)
        
        if let url = URL(string: movie.poster) {
            imagePoster.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder"),
                options: [.retryFailed, .refreshCached]
            )
        } else {
            imagePoster.image = UIImage(named: "placeholder")
        }
    }
    
    @objc
    func favoritesButtonAction() {
        guard let movie = currentMovie else { return }
        
        if isFavorite {
            DataManager.shared.removeFavorite(movieID: movie.imdbID)
        } else {
            DataManager.shared.addFavorite(movie: movie)
        }
        
        isFavorite.toggle()
        let starName = isFavorite ? "star.fill" : "star"
        favoritesButton.setImage(UIImage(systemName: starName), for: .normal)
        favoriteButtonTapped?(movie)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
}
