import UIKit
import SafariServices

class MainViewController: UIViewController {

    // Таблица с фильмами
    private let tableView = UITableView(frame: .zero, style: .plain)

    // Кнопка «звёздочка» в hero-блоке
    private var heroFavoriteButton = UIButton(type: .system)

    // Фильмы из API
    private var movies: [Movie] = []

    // Премьеры недели — возьмём первые N фильмов
    private var premieres: [Movie] {
        Array(movies.prefix(10))
    }

    // Жанры и текущий выбранный
    private let genres: [String] = ["All", "Action", "Sci-Fi", "Drama", "Comedy", "Other"]
    private var selectedGenre: String = "All"
    private var genreButtons: [UIButton] = []

    // Фильтрованный список для таблицы
    private var currentMovies: [Movie] {
        movies.filter { passesFilters($0) }
    }

    // Горизонтальный слайдер премьер
    private lazy var premieresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PremiereCell.self, forCellWithReuseIdentifier: "PremiereCell")
        return collectionView
    }()

    // MARK: - Жизненный цикл

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Main"

        tabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        setupTableView()
        setupHeaderView()     // дефолтный header
        loadMoviesFromAPI()   // подтягиваем реальные фильмы
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        premieresCollectionView.reloadData()
    }

    // MARK: - Загрузка из TMDb

    private func loadMoviesFromAPI() {
        MovieAPI.shared.fetchPopularMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let apiMovies):
                    let mapped = apiMovies.map { Movie(from: $0) }
                    self.movies = mapped

                    // Пересоздаём header с реальным первым фильмом
                    self.setupHeaderView()
                    self.tableView.reloadData()
                    self.premieresCollectionView.reloadData()

                case .failure(let error):
                    print("API error:", error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Фильтрация

    private func passesFilters(_ movie: Movie) -> Bool {
        // по жанру
        if selectedGenre != "All", movie.genre != selectedGenre {
            return false
        }

        // по рейтингу из Settings
        let highRatedOnly = UserDefaults.standard.bool(forKey: "settings_highRatedOnly")
        if highRatedOnly {
            let storedMin = UserDefaults.standard.double(forKey: "settings_minRating")
            let minRating = storedMin == 0 ? 8.0 : storedMin
            if movie.rating < minRating {
                return false
            }
        }

        return true
    }

    // MARK: - TableView

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
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground

        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
    }

    // MARK: - Header (hero + слайдер + жанры)

    private func setupHeaderView() {
        let headerWidth = view.bounds.width

        let headerView = UIView()
        headerView.backgroundColor = .systemBackground

        // обязательно выключаем autoresizingMask, раз используем AutoLayout
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // ---------- Верхний бар: логотип + аватар ----------

        let logoImageView = UIImageView(image: UIImage(systemName: "film"))
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit

        let logoLabel = UILabel()
        logoLabel.text = "CineScope"
        logoLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        let logoStack = UIStackView(arrangedSubviews: [logoImageView, logoLabel])
        logoStack.axis = .horizontal
        logoStack.spacing = 8
        logoImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let avatarButton = UIButton(type: .system)
        avatarButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        avatarButton.tintColor = .systemBlue
        avatarButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        avatarButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        avatarButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)

        let topBar = UIStackView(arrangedSubviews: [logoStack, UIView(), avatarButton])
        topBar.axis = .horizontal
        topBar.alignment = .center

        headerView.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false

        // ---------- Hero-блок ----------

        let heroContainer = UIView()
        heroContainer.layer.cornerRadius = 16
        heroContainer.clipsToBounds = true

        let heroImageView = UIImageView()
        heroImageView.contentMode = .scaleAspectFit
        heroImageView.clipsToBounds = true

        if let first = movies.first {
            if let url = first.posterURL {
                loadImage(into: heroImageView, from: url)
            } else if !first.posterName.isEmpty {
                heroImageView.image = UIImage(named: first.posterName)
            } else {
                heroImageView.image = UIImage(systemName: "film")
            }
        } else {
            heroImageView.image = UIImage(systemName: "film")
        }

        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.35)

        heroContainer.addSubview(heroImageView)
        heroContainer.addSubview(overlayView)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: heroContainer.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: heroContainer.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: heroContainer.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: heroContainer.bottomAnchor),

            overlayView.topAnchor.constraint(equalTo: heroContainer.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: heroContainer.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: heroContainer.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: heroContainer.bottomAnchor),
        ])

        let heroTitleLabel = UILabel()
        heroTitleLabel.textColor = .white
        heroTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        heroTitleLabel.text = movies.first?.title ?? "Movie title"

        let heroDescriptionLabel = UILabel()
        heroDescriptionLabel.textColor = .white
        heroDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        heroDescriptionLabel.numberOfLines = 2
        heroDescriptionLabel.text = movies.first?.description ?? "Movie description text goes here."

        let watchButton = UIButton(type: .system)
        watchButton.setTitle("Watch", for: .normal)
        watchButton.tintColor = .white
        watchButton.backgroundColor = .systemBlue
        watchButton.layer.cornerRadius = 12
        watchButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        watchButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
        watchButton.addTarget(self, action: #selector(heroWatchTapped), for: .touchUpInside)

        // звёздочка «в избранное»
        heroFavoriteButton = UIButton(type: .system)
        heroFavoriteButton.tintColor = .white
        heroFavoriteButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        heroFavoriteButton.layer.cornerRadius = 20
        heroFavoriteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        heroFavoriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        heroFavoriteButton.addTarget(self, action: #selector(heroFavoriteTapped), for: .touchUpInside)

        if let first = movies.first, FavoritesManager.shared.isFavorite(first) {
            heroFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            heroFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }

        // share-кнопка
        let shareButton = UIButton(type: .system)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .white
        shareButton.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        shareButton.layer.cornerRadius = 20
        shareButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let heroButtonsStack = UIStackView(arrangedSubviews: [watchButton, heroFavoriteButton, shareButton])
        heroButtonsStack.axis = .horizontal
        heroButtonsStack.spacing = 12
        heroButtonsStack.alignment = .center

        let heroTextStack = UIStackView(arrangedSubviews: [heroTitleLabel, heroDescriptionLabel, heroButtonsStack])
        heroTextStack.axis = .vertical
        heroTextStack.spacing = 8

        overlayView.addSubview(heroTextStack)
        heroTextStack.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(heroContainer)
        heroContainer.translatesAutoresizingMaskIntoConstraints = false

        // ---------- "Premieres of the week" ----------

        let premieresLabel = UILabel()
        premieresLabel.text = "Premieres of the week"
        premieresLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        premieresLabel.textColor = .label
        headerView.addSubview(premieresLabel)
        premieresLabel.translatesAutoresizingMaskIntoConstraints = false

        // ---------- CollectionView премьер ----------

        headerView.addSubview(premieresCollectionView)
        premieresCollectionView.translatesAutoresizingMaskIntoConstraints = false

        // ---------- Жанровые кнопки ----------

        let genresStack = createGenreButtonsStack()
        headerView.addSubview(genresStack)
        genresStack.translatesAutoresizingMaskIntoConstraints = false

        // ---------- Констрейнты ----------

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12),
            topBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            topBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            topBar.heightAnchor.constraint(equalToConstant: 32),

            heroContainer.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 12),
            heroContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            heroContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            heroContainer.heightAnchor.constraint(equalToConstant: 360),

            heroTextStack.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 16),
            heroTextStack.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -16),
            heroTextStack.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -20),

            // 👇 делаем, чтобы лейбл точно имел высоту
            premieresLabel.topAnchor.constraint(equalTo: heroContainer.bottomAnchor, constant: 16),
            premieresLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            premieresLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            premieresLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),

            premieresCollectionView.topAnchor.constraint(equalTo: premieresLabel.bottomAnchor, constant: 8),
            premieresCollectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            premieresCollectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            premieresCollectionView.heightAnchor.constraint(equalToConstant: 210),

            genresStack.topAnchor.constraint(equalTo: premieresCollectionView.bottomAnchor, constant: 16),
            genresStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            genresStack.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -16),
            genresStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16)
        ])

        // ---------- Высота headerView по AutoLayout ----------

        let container = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: 1))
        container.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: container.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        container.setNeedsLayout()
        container.layoutIfNeeded()

        let targetSize = CGSize(width: headerWidth, height: UIView.layoutFittingCompressedSize.height)
        let height = container.systemLayoutSizeFitting(targetSize).height
        container.frame.size.height = height

        tableView.tableHeaderView = container
    }

    // MARK: - Картинки из сети для hero

    private func loadImage(into imageView: UIImageView, from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }

    // MARK: - Жанровые кнопки

    private func createGenreButtonsStack() -> UIStackView {
        genreButtons = []

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill

        for genre in genres {
            let button = UIButton(type: .system)
            button.setTitle(genre, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            button.layer.cornerRadius = 16
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
            button.addTarget(self, action: #selector(genreTapped(_:)), for: .touchUpInside)

            if genre == selectedGenre {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .systemGray6
                button.setTitleColor(.label, for: .normal)
            }

            genreButtons.append(button)
            stack.addArrangedSubview(button)
        }

        return stack
    }

    @objc private func genreTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        selectedGenre = title

        for button in genreButtons {
            let isSelected = (button === sender)
            if isSelected {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .systemGray6
                button.setTitleColor(.label, for: .normal)
            }
        }

        tableView.reloadData()
    }

    // MARK: - Actions (hero)

    @objc private func heroWatchTapped() {
        guard let movie = movies.first else { return }
        openTrailer(for: movie)
    }

    @objc private func heroFavoriteTapped() {
        guard let movie = movies.first else { return }
        _ = FavoritesManager.shared.toggleFavorite(movie)

        let isFavNow = FavoritesManager.shared.isFavorite(movie)
        let imageName = isFavNow ? "star.fill" : "star"
        heroFavoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func profileTapped() {
        // Порядок вкладок: 0 - Main, 1 - Settings, 2 - Favorites, 3 - Search
        tabBarController?.selectedIndex = 1   // переходим в Settings
    }

    private func openTrailer(for movie: Movie) {
        let query = movie.trailerQuery
        guard
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://www.youtube.com/results?search_query=\(encoded)")
        else { return }

        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

// MARK: - UITableViewDataSource / Delegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        currentMovies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MovieCell",
            for: indexPath
        ) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = currentMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = currentMovies[indexPath.row]
        let detailsVC = MovieDetailsViewController()
        detailsVC.movie = movie
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource / DelegateFlowLayout

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        premieres.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PremiereCell",
            for: indexPath
        ) as? PremiereCell else {
            return UICollectionViewCell()
        }

        let movie = premieres[indexPath.item]
        cell.configure(with: movie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 140, height: 210)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let movie = premieres[indexPath.item]
        let detailsVC = MovieDetailsViewController()
        detailsVC.movie = movie
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
