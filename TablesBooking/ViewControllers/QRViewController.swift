//
//  QRViewController.swift
//  TablesBooking
//
//  Created by temir on 19.12.2020.
//

import Foundation
import UIKit

class QRViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let qrCodeImage = createQRCode() {
            qrImageView.image = qrCodeImage
        }
    }
    
    private func createQRCode() -> UIImage? {
        if let stringID = OrderManager.shared.orderID?.uuidString {
            let data = stringID.data(using: .ascii)
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                if let output = filter.outputImage?.transformed(by: transform) {
                    return UIImage(ciImage: output)
                }
            }
        } 
        
        return nil
    }
        
}
