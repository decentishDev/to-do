//
//  SettingsVC.swift
//  To Do
//
//  Created by Matthew Lundeen on 7/25/23.
//

import UIKit

class SettingsVC: UIViewController {
    let stackView = UIStackView()
    let defaults = UserDefaults.standard
    var settings: [String: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tryData = defaults.object(forKey: "settings") as? [String: Bool] {
            settings = tryData
        }else{
            settings = [
                "key1": true,
                "key2": false,
                "key3": true,
            ]
            defaults.set(settings, forKey: "settings")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
