import UIKit

class SettingsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // ключи в UserDefaults
    private let autoplayKey = "settings_autoplayTrailers"
    private let highRatedKey = "settings_highRatedOnly"
    private let minRatingKey = "settings_minRating"

    // удобные свойства
    private var isAutoplayEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: autoplayKey) }
        set { UserDefaults.standard.set(newValue, forKey: autoplayKey) }
    }

    private var isHighRatedOnlyEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: highRatedKey) }
        set { UserDefaults.standard.set(newValue, forKey: highRatedKey) }
    }

    /// минимум рейтинга для фильтрации (по умолчанию 8.0)
    private var minRating: Double {
        get {
            let value = UserDefaults.standard.double(forKey: minRatingKey)
            return value == 0 ? 8.0 : value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: minRatingKey)
        }
    }

    // чтобы обновлять текст у ячейки с ползунком
    private weak var ratingCell: UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Settings"

        tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        setupTableView()
    }

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
        tableView.rowHeight = 52

        // фейковый профиль-хедер
        tableView.tableHeaderView = createProfileHeader()
    }

    private func createProfileHeader() -> UIView {
        let headerWidth = view.bounds.width
        let headerHeight: CGFloat = 140

        let header = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight))
        header.backgroundColor = .systemBackground

        let avatarImageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        avatarImageView.tintColor = .systemBlue
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = 32
        avatarImageView.clipsToBounds = true

        let nameLabel = UILabel()
        nameLabel.text = "Gaukhar Zhanel"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)

        let emailLabel = UILabel()
        emailLabel.text = "zhgoha26@gmail.com"
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.textColor = .secondaryLabel

        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit profile", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        editButton.setTitleColor(.systemBlue, for: .normal)
        // пока без логики, просто фейковая кнопка

        header.addSubview(avatarImageView)
        header.addSubview(nameLabel)
        header.addSubview(emailLabel)
        header.addSubview(editButton)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: header.trailingAnchor, constant: -16),

            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.trailingAnchor.constraint(lessThanOrEqualTo: header.trailingAnchor, constant: -16),

            editButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            editButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])

        return header
    }
}   // ← вот этого закрывающего } у тебя не хватало

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2    // 1: Preferences, 2: About
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3    // autoplay, high-rated only, min rating
        case 1:
            return 2    // App, Version
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Preferences"
        case 1: return "About"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch (indexPath.section, indexPath.row) {

        case (0, 0):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Autoplay trailers"
            let switchView = UISwitch()
            switchView.isOn = isAutoplayEnabled
            switchView.addTarget(self, action: #selector(autoplayChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            cell.selectionStyle = .none
            return cell

        case (0, 1):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Show only high-rated"
            let switchView = UISwitch()
            switchView.isOn = isHighRatedOnlyEnabled
            switchView.addTarget(self, action: #selector(highRatedChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            cell.selectionStyle = .none
            return cell

        case (0, 2):
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.selectionStyle = .none

            let valueText = String(format: "%.1f", minRating)
            cell.textLabel?.text = "Minimum rating: \(valueText)"

            let slider = UISlider()
            slider.minimumValue = 0
            slider.maximumValue = 10
            slider.value = Float(minRating)
            slider.addTarget(self, action: #selector(minRatingChanged(_:)), for: .valueChanged)

            // accessoryView сам подбирает размер
            cell.accessoryView = slider
            ratingCell = cell

            return cell

        case (1, 0):
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.textLabel?.text = "App"
            cell.detailTextLabel?.text = "Movie Explorer"
            return cell

        case (1, 1):
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.selectionStyle = .none
            cell.textLabel?.text = "Version"
            cell.detailTextLabel?.text = "1.0"
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    // при необходимости можно обрабатывать нажатия на About
}

// MARK: - Actions

extension SettingsViewController {

    @objc private func autoplayChanged(_ sender: UISwitch) {
        isAutoplayEnabled = sender.isOn
        print("Autoplay trailers:", sender.isOn)
    }

    @objc private func highRatedChanged(_ sender: UISwitch) {
        isHighRatedOnlyEnabled = sender.isOn
        print("High-rated only:", sender.isOn)
    }

    @objc private func minRatingChanged(_ sender: UISlider) {
        // округляем до 0.1
        var value = Double(sender.value)
        value = (value * 10).rounded() / 10.0
        sender.value = Float(value)

        minRating = value

        let valueText = String(format: "%.1f", value)
        ratingCell?.textLabel?.text = "Minimum rating: \(valueText)"

        print("Min rating set to:", valueText)
    }
}

