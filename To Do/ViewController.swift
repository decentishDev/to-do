import UIKit

class ViewController: UIViewController {

    // The stack view that will contain the rectangles with labels
    let stackView = UIStackView()
    let defaults = UserDefaults.standard
    var userData: [[String]] = [[]]
    var currentFolder = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "pawel-czerwinski-Eru5-VMQZT8-unsplash.jpg")
//        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
//        view.addSubview(backgroundImage)
//        view.sendSubviewToBack(backgroundImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tryData = defaults.object(forKey: "data") as? [[String]] {
            userData = tryData
        }else{
            userData = [["Example folder", "Example task"]]
            defaults.set(userData, forKey: "data")
        }
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        for subview in view.subviews {
            subview.removeFromSuperview()
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

        for i in 0...(userData.count - 1) {
            let transparentView = UIView()
            transparentView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
            transparentView.layer.cornerRadius = 10
            stackView.addArrangedSubview(transparentView)

            let titleLabel = UILabel()
            titleLabel.text = userData[i][0]
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textAlignment = .left
            titleLabel.sizeToFit()
            let countLabel = UILabel()
            if(userData[i].count > 1){
                countLabel.text = "\(userData[i].count - 1)"
                countLabel.font = UIFont.boldSystemFont(ofSize: 20)
                countLabel.textAlignment = .right
                countLabel.sizeToFit()
                countLabel.translatesAutoresizingMaskIntoConstraints = false
                transparentView.addSubview(countLabel)
                NSLayoutConstraint.activate([
                    countLabel.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor),
                    countLabel.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -10)
                ])
            }

            let labelsStackView = UIStackView(arrangedSubviews: [titleLabel])

            if(userData[i].count == 1){
                titleLabel.textColor = UIColor.placeholderText
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
                labelsStackView.addArrangedSubview(descriptionLabel)
            }

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
            self.defaults.set(self.userData, forKey: "data")
            let transparentView = UIView()
            transparentView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
            transparentView.layer.cornerRadius = 10
            self.stackView.addArrangedSubview(transparentView)

            let titleLabel = UILabel()
            titleLabel.text = folderName
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textAlignment = .left
            titleLabel.sizeToFit()

            let labelsStackView = UIStackView(arrangedSubviews: [titleLabel])

            titleLabel.textColor = UIColor.placeholderText
            
            labelsStackView.axis = .vertical
            labelsStackView.spacing = 5
            labelsStackView.alignment = .leading
            labelsStackView.sizeToFit()
            labelsStackView.distribution = .fillProportionally

            transparentView.addSubview(labelsStackView)
            transparentView.sizeToFit()

            let backgroundButton = UIButton()
            backgroundButton.addTarget(self, action: #selector(self.openFolder), for: .touchUpInside)
            backgroundButton.backgroundColor = UIColor.clear
            backgroundButton.translatesAutoresizingMaskIntoConstraints = false
            backgroundButton.accessibilityIdentifier = String(self.userData.count - 1)
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
