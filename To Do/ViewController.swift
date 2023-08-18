import UIKit

class ViewController: UIViewController {

    // The stack view that will contain the rectangles with labels
    let stackView = UIStackView()
    let defaults = UserDefaults.standard
    var userData: [[String]] = [[]]
    var timeData: [[Int]] = [[]]
    var currentFolder = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tryData = defaults.object(forKey: "data") as? [[String]] {
            userData = tryData
        }else{
            userData = [["Example folder", "Example task"]]
            defaults.set(userData, forKey: "data")
        }
        if let tryData = defaults.object(forKey: "times") as? [[Int]] {
            timeData = tryData
        }else{
            timeData = [[10]]
            defaults.set(timeData, forKey: "times")
        }
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        // Create a UIImageView and set its frame to fill the entire view
        let backgroundImageView = UIImageView(frame: view.bounds)
        
        // Set the content mode to scale the image to fit the view bounds
        backgroundImageView.contentMode = .scaleAspectFill
        
        // Add the UIImageView to the view
        view.addSubview(backgroundImageView)
        
        // Send the UIImageView to the back so it acts as the background
        view.sendSubviewToBack(backgroundImageView)
        
        // Replace "backgroundImageName" with the name of your image file
        let backgroundImage = UIImage(named: "milad-fakurian-qCYKtOov--s-unsplash.jpg")
        
        // Set the image of the UIImageView
        backgroundImageView.image = backgroundImage
        
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])

        for i in 0..<(userData.count) {
            let blurEffect = UIBlurEffect(style: .regular) // Choose the desired blur style
            let blurredBackgroundView = UIVisualEffectView(effect: blurEffect)
            blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            blurredBackgroundView.layer.cornerRadius = 10
            blurredBackgroundView.clipsToBounds = true
            stackView.addArrangedSubview(blurredBackgroundView)

            let titleLabel = UILabel()
            titleLabel.text = userData[i][0]
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textAlignment = .left
            titleLabel.sizeToFit()
            titleLabel.textColor = ColorTheme.label
            let countLabel = UILabel()
            let timeLabel = UILabel()
            if(userData[i].count > 1){
                var t = 0
                for j in 0..<(timeData[i].count){
                    t += timeData[i][j]
                }
                print(t)
                timeLabel.text = String(format: "%02d:%02d", t / 60, t % 60)
                timeLabel.font = UIFont.systemFont(ofSize: 20)
                timeLabel.textAlignment = .right
                timeLabel.sizeToFit()
                timeLabel.translatesAutoresizingMaskIntoConstraints = false
                timeLabel.textColor = ColorTheme.label
                blurredBackgroundView.contentView.addSubview(timeLabel)
                countLabel.text = "\(userData[i].count - 1)"
                countLabel.font = UIFont.boldSystemFont(ofSize: 20)
                countLabel.textAlignment = .right
                countLabel.sizeToFit()
                countLabel.translatesAutoresizingMaskIntoConstraints = false
                countLabel.textColor = ColorTheme.label
                blurredBackgroundView.contentView.addSubview(countLabel)
                NSLayoutConstraint.activate([
                    timeLabel.centerYAnchor.constraint(equalTo: blurredBackgroundView.centerYAnchor),
                    timeLabel.trailingAnchor.constraint(equalTo: blurredBackgroundView.trailingAnchor, constant: -60),
                    countLabel.centerYAnchor.constraint(equalTo: blurredBackgroundView.centerYAnchor),
                    countLabel.trailingAnchor.constraint(equalTo: blurredBackgroundView.trailingAnchor, constant: -25)
                ])
            }

            let labelsStackView = UIStackView(arrangedSubviews: [titleLabel])

            if(userData[i].count == 1){
                titleLabel.textColor = ColorTheme.placeholderText
            }else{
                let descriptionLabel = UILabel()
                var desc = ""
                for j in 1...(userData[i].count - 1){
                    desc+=userData[i][j]
                    desc+=", "
                }
                desc = String(desc.prefix(desc.count - 2))
                descriptionLabel.numberOfLines = 5
                descriptionLabel.text = desc
                descriptionLabel.font = UIFont.systemFont(ofSize: 14)
                descriptionLabel.textAlignment = .left
                descriptionLabel.sizeToFit()
                descriptionLabel.textColor = ColorTheme.label
                labelsStackView.addArrangedSubview(descriptionLabel)
            }

            labelsStackView.axis = .vertical
            labelsStackView.spacing = 5
            labelsStackView.alignment = .leading
            labelsStackView.sizeToFit()
            labelsStackView.distribution = .fillProportionally

            blurredBackgroundView.contentView.addSubview(labelsStackView)
            blurredBackgroundView.sizeToFit()

            let backgroundButton = UIButton()
            backgroundButton.addTarget(self, action: #selector(openFolder), for: .touchUpInside)
            backgroundButton.backgroundColor = UIColor.clear
            backgroundButton.translatesAutoresizingMaskIntoConstraints = false
            backgroundButton.accessibilityIdentifier = String(i)
            blurredBackgroundView.contentView.addSubview(backgroundButton)

            NSLayoutConstraint.activate([
                backgroundButton.topAnchor.constraint(equalTo: blurredBackgroundView.topAnchor),
                backgroundButton.bottomAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor),
                backgroundButton.leadingAnchor.constraint(equalTo: blurredBackgroundView.leadingAnchor),
                backgroundButton.trailingAnchor.constraint(equalTo: blurredBackgroundView.trailingAnchor)
            ])

            labelsStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelsStackView.topAnchor.constraint(equalTo: blurredBackgroundView.topAnchor, constant: 10),
                labelsStackView.bottomAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor, constant: -10),
                labelsStackView.leadingAnchor.constraint(equalTo: blurredBackgroundView.leadingAnchor, constant: 10),
            ])
            if(userData[i].count > 1){
                NSLayoutConstraint.activate([
                    labelsStackView.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -10)
                ])
            }
        }


    }
    
    @objc func openFolder(sender: UIButton){
        let folder = sender.accessibilityIdentifier
        currentFolder = Int(folder ?? "0") ?? 0
        performSegue(withIdentifier: "folderSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "folderSegue"){
            let nextVC = (segue.destination as! TasksVC)
            var newData: [String] = []
            if(userData[currentFolder].count > 1){
                for i in 1...(userData[currentFolder].count - 1) {
                    newData.append(userData[currentFolder][i])
                }
            }
            nextVC.userData = newData
            nextVC.titleName = userData[currentFolder][0]
            nextVC.currentFolder = currentFolder
            nextVC.timeData = timeData[currentFolder]
        }
    }
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Folder", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Folder Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let folderName = alertController.textFields?.first?.text else { return }
            self.userData.append([folderName])
            self.timeData.append([])
            self.defaults.set(self.userData, forKey: "data")
            self.defaults.set(self.timeData, forKey: "times")
            let blurEffect = UIBlurEffect(style: .regular) // Choose the desired blur style
            let blurredBackgroundView = UIVisualEffectView(effect: blurEffect)
            blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            blurredBackgroundView.layer.cornerRadius = 10
            blurredBackgroundView.clipsToBounds = true
            self.stackView.addArrangedSubview(blurredBackgroundView)

            let titleLabel = UILabel()
            titleLabel.text = folderName
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textAlignment = .left
            titleLabel.sizeToFit()

            let labelsStackView = UIStackView(arrangedSubviews: [titleLabel])

            titleLabel.textColor = ColorTheme.placeholderText
            
            labelsStackView.axis = .vertical
            labelsStackView.spacing = 5
            labelsStackView.alignment = .leading
            labelsStackView.sizeToFit()
            labelsStackView.distribution = .fillProportionally

            blurredBackgroundView.contentView.addSubview(labelsStackView)
            blurredBackgroundView.sizeToFit()

            let backgroundButton = UIButton()
            backgroundButton.addTarget(self, action: #selector(self.openFolder), for: .touchUpInside)
            backgroundButton.backgroundColor = UIColor.clear
            backgroundButton.translatesAutoresizingMaskIntoConstraints = false
            backgroundButton.accessibilityIdentifier = String(self.userData.count - 1)
            blurredBackgroundView.contentView.addSubview(backgroundButton)

            NSLayoutConstraint.activate([
                backgroundButton.topAnchor.constraint(equalTo: blurredBackgroundView.topAnchor),
                backgroundButton.bottomAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor),
                backgroundButton.leadingAnchor.constraint(equalTo: blurredBackgroundView.leadingAnchor),
                backgroundButton.trailingAnchor.constraint(equalTo: blurredBackgroundView.trailingAnchor)
            ])

            labelsStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelsStackView.topAnchor.constraint(equalTo: blurredBackgroundView.topAnchor, constant: 10),
                labelsStackView.bottomAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor, constant: -10),
                labelsStackView.leadingAnchor.constraint(equalTo: blurredBackgroundView.leadingAnchor, constant: 10),
                labelsStackView.trailingAnchor.constraint(equalTo: blurredBackgroundView.trailingAnchor, constant: -10)
            ])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
