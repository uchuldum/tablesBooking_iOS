//
//  ViewController.swift
//  TablesBooking
//
//  Created by temir on 11.10.2020.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func goButtonAction(_ sender: Any) {
        if OrderManager.shared.selectedDate != nil {
            performSegue(withIdentifier: "showPlaces",
                         sender: self)
        }
    }
}

private extension StartViewController {
    
    @IBAction func selectDate(_ sender: UIDatePicker) {
        OrderManager.shared.selectedDate = sender.date
    }
}

