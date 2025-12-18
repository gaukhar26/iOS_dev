//
//  PremieresCell.swift
//  MovieApp
//
//  Created by ayan on 16.12.2025.
//

import UIKit
import SDWebImage

class PremiereCell: UICollectionViewCell {
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.image = UIImage(named: "placeholder")
        posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = UIImage(named: "placeholder")
        titleLabel.text = nil
        posterImageView.sd_cancelCurrentImageLoad()
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = "\(movie.title) (\(movie.year))"
        
        if let url = URL(string: movie.poster) {
            posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [.retryFailed, .refreshCached], context: nil)
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
}
