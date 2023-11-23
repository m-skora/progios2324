//
//  ViewController.swift
//  calc2
//
//  Created by user250042 on 11/9/23.
//

import UIKit

class ViewController: UIViewController {
    
    var currentInput: String = ""
    var firstOperand: Int = 0
    var selectedOperator: String?
    
    @IBOutlet weak var result: UILabel!
    
    func updateDisplay() {
        result.text = currentInput
    }
    
    @IBAction func digitClick(_ sender: UIButton) {
        if let buttonValue = sender.titleLabel?.text {
            currentInput += buttonValue
            updateDisplay()
        }
    }
    
    @IBAction func operatorClick(_ sender: UIButton) {
        if let currentNumber = Int(currentInput) {
            if let buttonValue = sender.titleLabel?.text {
                selectedOperator = buttonValue
                firstOperand = currentNumber
                currentInput = ""
                updateDisplay()
            }
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        currentInput = ""
        firstOperand = 0
        selectedOperator = nil
        updateDisplay()
    }
    
    @IBAction func calculation(_ sender: Any) {
        if let secondOperand = Int(currentInput), let operatorSymbol = selectedOperator {
            switch operatorSymbol {
            case "+":
                currentInput = String(firstOperand + secondOperand)
            case "-":
                currentInput = String(firstOperand - secondOperand)
            case "*":
                currentInput = String(firstOperand * secondOperand)
            case "/":
                if secondOperand != 0 {
                    currentInput = String(firstOperand / secondOperand)
                } else {
                    currentInput = "Error"
                }
            default:
                break
            }
            updateDisplay()
            selectedOperator = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        result.text = ""
    }
}
