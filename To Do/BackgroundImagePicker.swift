import UIKit

class BackgroundImagePicker: UIViewController {

    let backgroundImages = ["color1.png", "color2.png", "unsplash1.jpg", "unsplash2.jpg", "unsplash3.jpg", "unsplash4.jpg", "unsplash5.jpg", "unsplash6.jpg", "unsplash7.jpg", "unsplash8.jpg", "unsplash9.jpg", "unsplash10.jpg"]
    var currentBackground: String?
    var selectedButton: UIButton? // Track the selected button

    var buttonSize: CGFloat = 0
    let buttonSpacing: CGFloat = 20
    let numberOfColumns = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select an image"
        view.backgroundColor = UIColor.black
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        
        currentBackground = UserDefaults.standard.value(forKey: "groupsBackground") as? String
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.addSubview(scrollView)
        buttonSize = (screenWidth / CGFloat(numberOfColumns)) - ((buttonSpacing * CGFloat(numberOfColumns + 1)) / CGFloat(numberOfColumns))

        let numberOfRows = Int(ceil(Double(backgroundImages.count) / Double(numberOfColumns)))
        let contentHeight = CGFloat(numberOfRows) * (buttonSize + buttonSpacing)
        scrollView.contentSize = CGSize(width: screenWidth, height: contentHeight)
        
        for (index, imageName) in backgroundImages.enumerated() {
            let row = index / numberOfColumns
            let col = index % numberOfColumns

            let x = CGFloat(col) * (buttonSize + buttonSpacing)
            let y = CGFloat(row) * (buttonSize + buttonSpacing)

            let button = UIButton(frame: CGRect(x: x + buttonSpacing, y: y, width: buttonSize, height: buttonSize))
            button.tag = index
            scrollView.addSubview(button)

            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.layer.cornerRadius = 20
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = button.bounds
            button.addSubview(imageView)
            
            if imageName == currentBackground {
                selectedButton = button
                addCheckmark(to: button)
            }

            button.addTarget(self, action: #selector(backgroundButtonTapped(_:)), for: .touchUpInside)
        }
    }

    @objc func backgroundButtonTapped(_ sender: UIButton) {
        if sender.tag < backgroundImages.count {
            currentBackground = backgroundImages[sender.tag]
            let editing = UserDefaults.standard.value(forKey: "editingBackground")
            if(editing as! String == "groups"){
                UserDefaults.standard.set(currentBackground, forKey: "groupsBackground")
            }else if(editing as! String == "inbox"){
                UserDefaults.standard.set(currentBackground, forKey: "inboxBackground")
            }else{
                var userData = UserDefaults.standard.value(forKey: "data") as! [[String]]
                userData[Int(editing as! String) ?? 0][1] = currentBackground ?? "color1.jpg"
                UserDefaults.standard.set(userData, forKey: "data")
            }
            updateCheckmark(for: sender)
        }
    }

    func addCheckmark(to button: UIButton) {
            let checkmarkSize: CGFloat = 80
            let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkImageView.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            checkmarkImageView.frame = CGRect(x: (button.frame.width - checkmarkSize) / 2, y: (button.frame.height - checkmarkSize) / 2, width: checkmarkSize, height: checkmarkSize)
        checkmarkImageView.contentMode = .scaleAspectFit
            button.addSubview(checkmarkImageView)
        }


    func updateCheckmark(for button: UIButton) {
        selectedButton?.subviews[1].removeFromSuperview()
        addCheckmark(to: button)
        selectedButton = button
    }
    
    
}
