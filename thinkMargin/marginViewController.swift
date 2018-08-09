//
//  marginViewController.swift
//  thinkMargin
//
//  Created by Ahmed ElSenousi on 20/09/2015.
//  Copyright © 2015 Ahmed ElSenousi. All rights reserved.
//

import UIKit

class marginViewController: UIViewController, UITextFieldDelegate {
    
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
    
    let segment = UISegmentedControl(items: ["Price (excl. VAT) :","Price (incl. VAT) :"])
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Margin", image: UIImage(named: "percentage"), tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profitTextField.userInteractionEnabled = false
        marginTextField.userInteractionEnabled = false
        profitLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        marginLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        
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
        segment.addTarget(self, action: #selector(marginViewController.action), forControlEvents: .ValueChanged);
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    
    func action() {
        if segment.selectedSegmentIndex == 0 {
            excVATTextField.borderStyle = UITextBorderStyle.RoundedRect
            incVATTextField.borderStyle = UITextBorderStyle.None
        } else {
            incVATTextField.borderStyle = UITextBorderStyle.RoundedRect
            excVATTextField.borderStyle = UITextBorderStyle.None
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
        
        if textField == incVATTextField {
            segment.selectedSegmentIndex = 1
            incVATTextField.borderStyle = UITextBorderStyle.RoundedRect
            excVATTextField.borderStyle = UITextBorderStyle.None
        }
        if textField == excVATTextField {
            segment.selectedSegmentIndex = 0
            excVATTextField.borderStyle = UITextBorderStyle.RoundedRect
            incVATTextField.borderStyle = UITextBorderStyle.None
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == incVATTextField {
            calculateUsingIncVAT()
        } else {
            calculate()
        }
    }
    
    func calculate() {
        
        let vat, cost, excvat: Float
        
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
        
        if let text = excVATTextField.text {
            if let number = Float(text) {
                excvat = number
            } else {
                excvat = 0
            }
        } else {
            excvat = 0
        }
        
        let incvat = excvat+(excvat*vat/100.0)
        let profit = excvat - cost
        let margin = (1 - cost/excvat)*100
        
        VATTextField.text = String(format: "%.02f", vat)
        costTextField.text = String(format: "%.02f", cost)
        marginTextField.text = String(format: "%.02f", margin)
        profitTextField.text = String(format: "%.02f", profit)
        excVATTextField.text = String(format: "%.02f", excvat)
        incVATTextField.text = String(format: "%.02f", incvat)
    }
    
    func calculateUsingIncVAT() {
        
        let vat, cost, incvat: Float
        
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
        
        if let text = incVATTextField.text {
            if let number = Float(text) {
                incvat = number
            } else {
                incvat = 0
            }
        } else {
            incvat = 0
        }
        
        let excvat = incvat*100.0/(100.0+vat)
        let profit = excvat - cost
        let margin = (1 - cost/excvat)*100
        
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
        
        marginTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        marginTextField.center = CGPointMake(marginLabel.center.x+marginLabel.frame.width/2+marginTextField.frame.width/1.8, marginLabel.center.y)
        marginTextField.keyboardType = UIKeyboardType.DecimalPad
        //        marginTextField.borderStyle = UITextBorderStyle.RoundedRect
        marginTextField.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.view.addSubview(marginTextField)
        
        profitTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        profitTextField.center = CGPointMake(profitLabel.center.x+profitLabel.frame.width/2+profitTextField.frame.width/1.8, profitLabel.center.y)
        profitTextField.keyboardType = UIKeyboardType.DecimalPad
        //        profitTextField.borderStyle = UITextBorderStyle.RoundedRect
        profitTextField.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.view.addSubview(profitTextField)
        
        excVATTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        excVATTextField.center = CGPointMake(segment.center.x-segment.frame.size.width/4, segment.center.y+excVATTextField.frame.height)
        excVATTextField.keyboardType = UIKeyboardType.DecimalPad
        //        excVATTextField.borderStyle = UITextBorderStyle.RoundedRect
        excVATTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(excVATTextField)
        
        incVATTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        incVATTextField.center = CGPointMake(segment.center.x+segment.frame.size.width/4, segment.center.y+incVATTextField.frame.height)
        incVATTextField.keyboardType = UIKeyboardType.DecimalPad
        incVATTextField.borderStyle = UITextBorderStyle.RoundedRect
        incVATTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(incVATTextField)
    }
    
    
    func setupLabels() {
        
        marginLabel.frame = CGRectMake(0, 0, 150.0, 22.0)
        marginLabel.center = CGPointMake(CGRectGetMidX(self.view.frame)-marginLabel.frame.width/2, CGRectGetMidY(self.view.frame))
        marginLabel.textAlignment = NSTextAlignment.Right
        marginLabel.text = "Margin % :"
        self.view.addSubview(marginLabel)
        
        // below center
        
        profitLabel.frame = marginLabel.frame
        profitLabel.center = CGPointMake(marginLabel.center.x,marginLabel.center.y+marginLabel.frame.height*2)
        profitLabel.textAlignment = NSTextAlignment.Right
        profitLabel.text = "Profit :"
        self.view.addSubview(profitLabel)
        
        
        // above center
        
        segment.frame = CGRectMake(0, 0, 280.0, 25.0)
        segment.center = CGPointMake(CGRectGetMidX(self.view.frame),marginLabel.center.y-marginLabel.frame.height*3.5)
        segment.selectedSegmentIndex = 1
        self.view.addSubview(segment)
        
        costLabel.frame = marginLabel.frame
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
        resetButton.addTarget(self, action: #selector(marginViewController.reset), forControlEvents: UIControlEvents.TouchUpInside)
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

