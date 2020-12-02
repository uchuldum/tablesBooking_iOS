//
//  ViewController.swift
//  TablesBooking
//
//  Created by temir on 11.10.2020.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    private var dayPicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    
    private var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayTextField.delegate = self
        timeTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func selectDay(_ sender: Any) {
        
    }
    
    @IBAction func selectTime(_ sender: Any) {
        
    }
    
    @IBAction func goButtonAction(_ sender: Any) {
        
    }
}

extension StartViewController: UITextFieldDelegate {
}

