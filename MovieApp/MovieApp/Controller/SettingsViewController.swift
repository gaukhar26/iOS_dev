//
//  SettingsViewController.swift
//  MovieApp
//
//  Created by goha on 18.12.2025.
//
import UIKit

class SettingsViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let darkModeSwitch = UISwitch()

    lazy var darkModeView = SettingsCardView(
        icon: "moon",
        title: "Dark mode",
        control: darkModeSwitch
    )
    
    let ratingSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 7.0
        return slider
    }()
    
    let languageControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["EN", "RU"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    var ratingValue: Float = 7.0

    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear favorites", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.05
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let tabBarSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let isDark = UserDefaults.standard.bool(forKey: "isDarkMode")
        darkModeSwitch.isOn = isDark
        applyTheme(isDark: isDark)

        setupUI()
        
    }
}

// MARK: - Setup UI & Actions
extension SettingsViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(containerStack)
        view.addSubview(clearButton)
        view.addSubview(tabBarSeparator)

        ratingSlider.addTarget(self, action: #selector(ratingChanged(_:)), for: .valueChanged)
        let ratingCard = SettingsCardView(icon: nil, title: "Minimum rating", control: ratingSlider)
        ratingCard.onSliderValueChanged = { [weak self] value in
            self?.ratingValue = value
        }
        let languageCard = SettingsCardView(icon: "globe", title: "Language", control: languageControl)
        
        clearButton.addTarget(self, action: #selector(clearFavoritesTapped), for: .touchUpInside)

        containerStack.addArrangedSubview(darkModeView)
        containerStack.addArrangedSubview(ratingCard)
        containerStack.addArrangedSubview(languageCard)
        
        darkModeSwitch.addTarget(
            self,
            action: #selector(darkModeChanged(_:)),
            for: .valueChanged
        )

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            containerStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            clearButton.topAnchor.constraint(equalTo: containerStack.bottomAnchor, constant: 16),
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            clearButton.heightAnchor.constraint(equalToConstant: 56),
            
            tabBarSeparator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBarSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc
    func darkModeChanged(_ sender: UISwitch) {
        let isDark = sender.isOn
        UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        applyTheme(isDark: isDark)
    }
    
    @objc
    func ratingChanged(_ sender: UISlider) {
        let value = round(sender.value * 10) / 10
        ratingValue = value
    }
    @objc
    func clearFavoritesTapped() {
        let alert = UIAlertController(title: "Clear Favorites",
                                      message: "Are you sure you want to delete all favorite movies?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            DataManager.shared.deleteAllFavorites()
        }))
        present(alert, animated: true, completion: nil)
    }

    func applyTheme(isDark: Bool) {
        let style: UIUserInterfaceStyle = isDark ? .dark : .light

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = style
            clearButton.backgroundColor = isDark ? .systemBlue : .systemBackground
            clearButton.setTitleColor(isDark ? .white : .systemRed, for: .normal)
        }
    }
}

class SettingsCardView: UIView {
    
    var onSliderValueChanged: ((Float) -> Void)?
    private let valueLabel = UILabel()
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    
    init(icon: String?, title: String, control: UIView) {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.alignment = .center
        topRow.spacing = 12
        
        if let iconName = icon {
            iconView.image = UIImage(systemName: iconName)
            iconView.tintColor = .gray
            topRow.addArrangedSubview(iconView)
        }

        topRow.addArrangedSubview(titleLabel)
        topRow.addArrangedSubview(UIView())
        topRow.addArrangedSubview(control)

        addSubview(topRow)
        topRow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topRow.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            topRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])

        if let slider = control as? UISlider {
            addSubview(slider)
            slider.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                slider.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 12),
                slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ])
        } else {
            topRow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
