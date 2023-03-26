import UIKit

class ViewController: UIViewController {

    // The stack view that will contain the rectangles with labels
    let stackView = UIStackView()
    let defaults = UserDefaults.standard
    var userData: [[String]] = [[]]
    var currentFolder = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tryData = defaults.object(forKey: "data") as? [[String]] {
            userData = tryData
        }else{
            userData = [["Math", "Assignment 1"]]
        }

        // Configure the stack view
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill

        // Add the stack view to the scroll view
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)

        // Enable auto-layout constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])

        for i in 1...20 {
            let transparentView = UIView()
            transparentView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
            transparentView.layer.cornerRadius = 10
            stackView.addArrangedSubview(transparentView)

            let titleLabel = UILabel()
            titleLabel.text = "Title \(i)"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textAlignment = .left
            titleLabel.sizeToFit()

            let descriptionLabel = UILabel()
            descriptionLabel.text = "Description \(i)"
            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            descriptionLabel.textAlignment = .left
            descriptionLabel.sizeToFit()

            let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
            labelsStackView.axis = .vertical
            labelsStackView.spacing = 5
            labelsStackView.alignment = .leading
            labelsStackView.sizeToFit()
            labelsStackView.distribution = .fillProportionally

            transparentView.addSubview(labelsStackView)
            transparentView.sizeToFit()

            let backgroundButton = UIButton()
            backgroundButton.addTarget(self, action: #selector(openFolder), for: .touchUpInside)
            backgroundButton.backgroundColor = UIColor.clear
            backgroundButton.translatesAutoresizingMaskIntoConstraints = false
            backgroundButton.accessibilityIdentifier = String(i)
            transparentView.addSubview(backgroundButton)

            NSLayoutConstraint.activate([
                backgroundButton.topAnchor.constraint(equalTo: transparentView.topAnchor),
                backgroundButton.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor),
                backgroundButton.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor),
                backgroundButton.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor)
            ])

            labelsStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelsStackView.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 10),
                labelsStackView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: -10),
                labelsStackView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 10),
                labelsStackView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -10)
            ])
        }
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "pawel-czerwinski-Eru5-VMQZT8-unsplash.jpg")
//        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
//        view.addSubview(backgroundImage)
//        view.sendSubviewToBack(backgroundImage)
    }
    
    @objc func openFolder(sender: UIButton){
        performSegue(withIdentifier: "folderSegue", sender: nil)
        let folder = sender.accessibilityIdentifier
        currentFolder = Int(folder ?? "0") ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = (segue.destination as! TasksVC)
        nextVC.userData = userData
        nextVC.currentFolder = currentFolder
    }
}
