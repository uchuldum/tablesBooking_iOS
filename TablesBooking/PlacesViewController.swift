//
//  PlacesViewController.swift
//  TablesBooking
//
//  Created by temir on 18.12.2020.
//

import Foundation
import UIKit

class PlacesViewController: UIViewController {
    
    @IBOutlet var placeButtons: [UIButton]!
    
    private var placeName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func selectPlace(_ sender: UIButton) {
        placeButtons.forEach { (button) in
            button.layer.borderWidth = 0.0
        }
        let tag = sender.tag
        if let selectedButton = placeButtons.filter({ $0.tag == tag }).first {
            selectedButton.layer.borderWidth = 2.0
            selectedButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            placeName = "\(selectedButton.tag)"
        }
    }
    
    @IBAction private func bookPlace() {
        OrderManager.shared.makeOrder(for: placeName) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .booked:
                    print("this place booked")
                case .succeed:
                    self?.performSegue(withIdentifier: "showQR", sender: self)
                case .error:
                    print("error")
                }
            }
        }
    }
}
