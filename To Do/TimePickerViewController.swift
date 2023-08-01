import UIKit

class TimePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var completionHandler: ((Int, Int) -> Void)?
    let pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)

        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -18)
        ])

        // Add a custom toolbar with "Done" and "Cancel" buttons
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        view.addSubview(toolbar)

        // Add constraints for the toolbar
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44)
        ])
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
//                navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        preferredContentSize = CGSize(width: 350, height: 275)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // Two components for hours and minutes
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // Hours component
            return 24 // 0 to 23 hours
        } else { // Minutes component
            return 60 // 0 to 59 minutes
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { // Hours component
            return "\(row) hours"
        } else { // Minutes component
            return "\(row) minutes"
        }
    }
    @objc func doneButtonTapped() {
        let selectedHour = pickerView.selectedRow(inComponent: 0)
        let selectedMinute = pickerView.selectedRow(inComponent: 1)
        completionHandler?(selectedHour, selectedMinute)
        dismiss(animated: true, completion: nil)
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

//    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
//        let selectedHour = pickerView.selectedRow(inComponent: 0)
//        let selectedMinute = pickerView.selectedRow(inComponent: 1)
//        completionHandler?(selectedHour, selectedMinute)
//        dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
}
