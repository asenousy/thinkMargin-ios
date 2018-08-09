//
//  priceViewController.swift
//  thinkMargin
//
//  Created by Ahmed ElSenousi on 20/09/2015.
//  Copyright © 2015 Ahmed ElSenousi. All rights reserved.
//

import UIKit

class priceViewController: UIViewController, UITextFieldDelegate {
    
    let VATLabel = UILabel()
    let costLabel = UILabel()
    let marginLabel = UILabel()
    let profitLabel = UILabel()
    let excVATLabel = UILabel()
    let incVATLabel = UILabel()
    
    let VATTextField = UITextField()
    let costTextField = UITextField()
    let marginTextField = UITextField()
    let profitTextField = UITextField()
    let excVATTextField = UITextField()
    let incVATTextField = UITextField()
    
    let resetButton = UIButton(type: UIButtonType.RoundedRect)
    
    let segment = UISegmentedControl(items: ["Margin % :","Profit :"])
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Price", image: UIImage(named: "TagPrice"), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        excVATTextField.userInteractionEnabled = false
        incVATTextField.userInteractionEnabled = false
        excVATLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        incVATLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        
        VATTextField.delegate = self
        costTextField.delegate = self
        marginTextField.delegate = self
        profitTextField.delegate = self
        excVATTextField.delegate = self
        incVATTextField.delegate = self
        
        VATTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        costTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        marginTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        profitTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        excVATTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        incVATTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        setupLabels()
        setupTextfields()
        
//        segment.addTarget(self, action: "action", forControlEvents: .ValueChanged);
        segment.addTarget(self, action: #selector(priceViewController.action), forControlEvents: .ValueChanged);
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
        
    }
    
    func action() {
        if segment.selectedSegmentIndex == 0 {
            marginTextField.borderStyle = UITextBorderStyle.RoundedRect
            profitTextField.borderStyle = UITextBorderStyle.None
        } else {
            profitTextField.borderStyle = UITextBorderStyle.RoundedRect
            marginTextField.borderStyle = UITextBorderStyle.None
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if let text = textField.text {
            if Float(text) == 0 {
                textField.text!.removeAll()
            } else {
                if text.hasSuffix(".00") {
                    textField.text = text.stringByReplacingOccurrencesOfString(".00", withString: "")
                }
            }
        }
        
        if textField == profitTextField {
            segment.selectedSegmentIndex = 1
            profitTextField.borderStyle = UITextBorderStyle.RoundedRect
            marginTextField.borderStyle = UITextBorderStyle.None
        }
        if textField == marginTextField {
            segment.selectedSegmentIndex = 0
            marginTextField.borderStyle = UITextBorderStyle.RoundedRect
            profitTextField.borderStyle = UITextBorderStyle.None
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if segment.selectedSegmentIndex == 0 {
            calculate()
        } else {
            calculateUsingProfit()
        }
    }
    
    func calculate() {
        
        let vat, cost, margin: Float
        
        if let text = VATTextField.text {
            if let number = Float(text) {
                vat = number
            } else {
                vat = 0
            }
        } else {
            vat = 0
        }
        
        if let text = costTextField.text {
            if let number = Float(text) {
                cost = number
            } else {
                cost = 0
            }
        } else {
            cost = 0
        }
        
        if let text = marginTextField.text {
            if let number = Float(text) {
                margin = number
            } else {
                margin = 0
            }
        } else {
            margin = 0
        }
        
        let excvat = cost/(1.0-(margin/100))
        let profit = excvat - cost
        let incvat = excvat+(excvat*vat/100.0)
        VATTextField.text = String(format: "%.02f", vat)
        costTextField.text = String(format: "%.02f", cost)
        marginTextField.text = String(format: "%.02f", margin)
        profitTextField.text = String(format: "%.02f", profit)
        excVATTextField.text = String(format: "%.02f", excvat)
        incVATTextField.text = String(format: "%.02f", incvat)
    }
    
    func calculateUsingProfit() {
        
        let vat, cost, profit: Float
        
        if let text = VATTextField.text {
            if let number = Float(text) {
                vat = number
            } else {
                vat = 0
            }
        } else {
            vat = 0
        }
        
        if let text = costTextField.text {
            if let number = Float(text) {
                cost = number
            } else {
                cost = 0
            }
        } else {
            cost = 0
        }
        
        if let text = profitTextField.text {
            if let number = Float(text) {
                profit = number
            } else {
                profit = 0
            }
        } else {
            profit = 0
        }
        
        let margin = profit*100.0/(cost+profit)
        let excvat = cost/(1.0-(margin/100))
        let incvat = excvat+(excvat*vat/100.0)
        VATTextField.text = String(format: "%.02f", vat)
        costTextField.text = String(format: "%.02f", cost)
        marginTextField.text = String(format: "%.02f", margin)
        profitTextField.text = String(format: "%.02f", profit)
        excVATTextField.text = String(format: "%.02f", excvat)
        incVATTextField.text = String(format: "%.02f", incvat)
    }
    
    
    func setupTextfields() {
        
        VATTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        VATTextField.center = CGPointMake(VATLabel.center.x+VATLabel.frame.width/2+VATTextField.frame.width/1.8, VATLabel.center.y)
        VATTextField.keyboardType = UIKeyboardType.DecimalPad
        VATTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(VATTextField)
        
        costTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        costTextField.center = CGPointMake(costLabel.center.x+costLabel.frame.width/2+costTextField.frame.width/1.8, costLabel.center.y)
        costTextField.keyboardType = UIKeyboardType.DecimalPad
        costTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(costTextField)
        
        
        
        excVATTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        excVATTextField.center = CGPointMake(excVATLabel.center.x+excVATLabel.frame.width/2+excVATTextField.frame.width/1.8, excVATLabel.center.y)
        excVATTextField.keyboardType = UIKeyboardType.DecimalPad
        //        excVATTextField.borderStyle = UITextBorderStyle.RoundedRect
        excVATTextField.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.view.addSubview(excVATTextField)
        
        incVATTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        incVATTextField.center = CGPointMake(incVATLabel.center.x+incVATLabel.frame.width/2+incVATTextField.frame.width/1.8, incVATLabel.center.y)
        incVATTextField.keyboardType = UIKeyboardType.DecimalPad
        //        incVATTextField.borderStyle = UITextBorderStyle.RoundedRect
        incVATTextField.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.view.addSubview(incVATTextField)
        
        marginTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        marginTextField.center = CGPointMake(segment.center.x-segment.frame.size.width/4, segment.center.y+marginTextField.frame.height)
        marginTextField.keyboardType = UIKeyboardType.DecimalPad
        marginTextField.borderStyle = UITextBorderStyle.RoundedRect
        marginTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(marginTextField)
        
        profitTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        profitTextField.center = CGPointMake(segment.center.x+segment.frame.size.width/4, segment.center.y+profitTextField.frame.height)
        profitTextField.keyboardType = UIKeyboardType.DecimalPad
        //        profitTextField.borderStyle = UITextBorderStyle.RoundedRect
        profitTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(profitTextField)
    }
    
    
    func setupLabels() {
        
        excVATLabel.frame = CGRectMake(0, 0, 150.0, 22.0)
        excVATLabel.center = CGPointMake(CGRectGetMidX(self.view.frame)-excVATLabel.frame.width/2, CGRectGetMidY(self.view.frame))
        excVATLabel.textAlignment = NSTextAlignment.Right
        excVATLabel.text = "Price (excl. VAT) :"
        self.view.addSubview(excVATLabel)
        
        // below center
        
        incVATLabel.frame = excVATLabel.frame
        incVATLabel.center = CGPointMake(excVATLabel.center.x,excVATLabel.center.y+excVATLabel.frame.height*2)
        incVATLabel.textAlignment = NSTextAlignment.Right
        incVATLabel.text = "Price (incl. VAT) :"
        self.view.addSubview(incVATLabel)
        
        
        // above center
        
        segment.frame = CGRectMake(0, 0, 280.0, 25.0)
        segment.center = CGPointMake(CGRectGetMidX(self.view.frame),excVATLabel.center.y-excVATLabel.frame.height*3.5)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        costLabel.frame = excVATLabel.frame
        costLabel.center = CGPointMake(segment.center.x-costLabel.frame.width/2,segment.center.y-segment.frame.height*2)
        costLabel.textAlignment = NSTextAlignment.Right
        costLabel.text = "Cost :"
        self.view.addSubview(costLabel)
        
        VATLabel.frame = costLabel.frame
        VATLabel.center = CGPointMake(costLabel.center.x,costLabel.center.y-costLabel.frame.height*2)
        VATLabel.textAlignment = NSTextAlignment.Right
        VATLabel.text = "VAT % :"
        self.view.addSubview(VATLabel)
        
        resetButton.frame = costLabel.frame
        resetButton.center = CGPointMake(resetButton.frame.size.width/3, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - resetButton.frame.size.height*2)
        resetButton.setTitle("Reset", forState: UIControlState.Normal)
//        resetButton.addTarget(self, action: "reset", forControlEvents: UIControlEvents.TouchUpInside)
        resetButton.addTarget(self, action: #selector(priceViewController.reset), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(resetButton)
    }
    
    func reset() {
        VATTextField.text!.removeAll()
        costTextField.text!.removeAll()
        excVATTextField.text!.removeAll()
        incVATTextField.text!.removeAll()
        marginTextField.text!.removeAll()
        profitTextField.text!.removeAll()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

