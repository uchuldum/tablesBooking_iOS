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
        } else {
            let alert = UIAlertController(title: "Дата не выбрана",
                                          message: "Выберите дату",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Продолжить",
                                          style: .default,
                                          handler: nil))
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
}

private extension StartViewController {
    
    @IBAction func selectDate(_ sender: UIDatePicker) {
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: sender.date)
        OrderManager.shared.selectedDate = date
    }
}

