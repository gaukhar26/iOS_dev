import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var leftDiceImageView: UIImageView!
    @IBOutlet weak var rightDiceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        // Массив с картинками кубиков
        let diceArray = [
            UIImage(named: "dice1"),
            UIImage(named: "dice2"),
            UIImage(named: "dice3"),
            UIImage(named: "dice4"),
            UIImage(named: "dice5"),
            UIImage(named: "dice6")
        ].compactMap { $0 } // убирает nil, если что-то не найдено

        // Случайно выбираем по одному кубику
        leftDiceImageView.image = diceArray.randomElement()
        rightDiceImageView.image = diceArray.randomElement()
    }

}

