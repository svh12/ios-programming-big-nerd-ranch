//
//  File.swift
//  WorldTrotter
//
//  Created by Stephanie Hoang on 5/27/20.
//  Copyright © 2020 Stephanie Hoang. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    // Update Celsius label when app first launches
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check that viewDidLoad() is called
        print("ConversionViewController loaded its view.")
        
        // Display initial Celsius label
        updateCelsiusLabel()
    }
    
    // If Fahrenheit text field changes, update Fahrenheit value
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        
        // Convert text field's string into a number in a locale-independent way
        if let text = textField.text, let number = numberFormatter.number(from: text) {
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    // Dismiss keyboard when user clicks background view
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    // When Fahrenheit value changes, update Celsius label
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    // Convert Fahrenheit value to Celsius value
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    // Update Celsius label with Celsius value
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    // Update precision of Celsius value
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    } ()

    // Reject more than 1 decimal separator in text field
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentLocale = Locale.current
        let decimalSeparator = currentLocale.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
        
        if existingTextHasDecimalSeparator != nil,
            replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
    
}
