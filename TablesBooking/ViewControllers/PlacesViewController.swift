//
//  PlacesViewController.swift
//  TablesBooking
//
//  Created by temir on 18.12.2020.
//

import Foundation
import UIKit

class PlacesViewController: UIViewController {
    
    @IBOutlet private var placeButtons: [UIButton]!
    @IBOutlet private weak var loaderIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var bookButton: UIButton!
    
    private var placeName = ""
    
    private var bookedAlert: UIAlertController {
        let alertVC = UIAlertController(title: "Место забронировано",
                                        message: "На выбранную дату данное место забронировано",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK",
                                        style: .default,
                                        handler: nil))
        return alertVC
    }
    
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
        loaderIndicator.isHidden = false
        bookButton.isHidden = true
        loaderIndicator.startAnimating()
        OrderManager.shared.makeOrder(for: placeName) { [weak self] status in
            DispatchQueue.main.async {
                self?.loaderIndicator.stopAnimating()
                self?.bookButton.isHidden = false
                switch status {
                case .booked:
                    print("this place booked")
                    if let alert = self?.bookedAlert {
                        self?.present(alert,
                                      animated: true,
                                      completion: nil)
                    }
                case .succeed:
                    self?.performSegue(withIdentifier: "showQR", sender: self)
                case .error:
                    print("error")
                }
                // не должно быть default?
            }
        }
    }
}
