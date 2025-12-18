//
//  ViewController.swift
//  MovieApp
//
//  Created by ayan on 15.12.2025.
//

import UIKit

class MainViewController: UIViewController {

    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let navBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "CineScope"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let profileImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        iv.tintColor = UIColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 1.0)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let heroTitle: UILabel = {
        let label = UILabel()
        label.text = "Inception"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let heroSubtitle: UILabel = {
        let label = UILabel()
        label.text = "A mind-bending thriller about dreams within dreams and the power of ideas."
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let watchButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Watch"
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let sectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Premieres of the week"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 250)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let isDark = UserDefaults.standard.bool(forKey: "isDarkMode")
        applyTheme(isDark: isDark)
        setupHierarchy()
        setupConstraints()

        Services.shared.searchMovies(query: "Spiderman") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
        }
    }

    func applyTheme(isDark: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }

        view.backgroundColor = .systemBackground
        navBar.backgroundColor = .systemBackground
        logoLabel.textColor = .label
        heroTitle.textColor = isDark ? .white : .white
        heroSubtitle.textColor = isDark ? UIColor(white: 0.9, alpha: 1) : UIColor.white.withAlphaComponent(0.9)
        watchButton.configuration?.baseBackgroundColor = isDark ? .systemBlue : .systemBlue
    }

    func setupHierarchy() {
        view.addSubview(navBar)
        navBar.addSubview(logoLabel)
        navBar.addSubview(profileImageView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroImageView)
        heroImageView.addSubview(heroTitle)
        heroImageView.addSubview(heroSubtitle)
        heroImageView.addSubview(watchButton)
        
        contentView.addSubview(sectionTitle)
        contentView.addSubview(collectionView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 60),

            logoLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            logoLabel.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),

            profileImageView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -16),
            profileImageView.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 36),
            profileImageView.heightAnchor.constraint(equalToConstant: 36),

            scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            heroImageView.heightAnchor.constraint(equalToConstant: 450),

            watchButton.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 20),
            watchButton.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -30),
            watchButton.widthAnchor.constraint(equalToConstant: 160),
            watchButton.heightAnchor.constraint(equalToConstant: 44),

            heroSubtitle.bottomAnchor.constraint(equalTo: watchButton.topAnchor, constant: -16),
            heroSubtitle.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 20),
            heroSubtitle.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: -20),

            heroTitle.bottomAnchor.constraint(equalTo: heroSubtitle.topAnchor, constant: -8),
            heroTitle.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 20),

            sectionTitle.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 24),
            sectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            collectionView.topAnchor.constraint(equalTo: sectionTitle.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 260),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.item]
        cell.configure(title: movie.title, rating: "\(movie.rank)", posterURL: movie.poster)
        return cell
    }
}
