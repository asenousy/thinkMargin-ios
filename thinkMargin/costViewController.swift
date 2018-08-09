//
//  costViewController.swift
//  thinkMargin
//
//  Created by Ahmed ElSenousi on 20/09/2015.
//  Copyright © 2015 Ahmed ElSenousi. All rights reserved.
//

import UIKit

class costViewController: UIViewController, UITextFieldDelegate {
    
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
    
    let priceSegment = UISegmentedControl(items: ["Price (excl. VAT) :","Price (incl. VAT) :"])
    let marginSegment = UISegmentedControl(items: ["Margin % :","Profit :"])
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = UITabBarItem(title: "Cost", image: UIImage(named: "Cost"), tag: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        costTextField.userInteractionEnabled = false
        costLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        
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
        
//        priceSegment.addTarget(self, action: "action1", forControlEvents: .ValueChanged);
//        marginSegment.addTarget(self, action: "action2", forControlEvents: .ValueChanged);
        priceSegment.addTarget(self, action: #selector(costViewController.action1), forControlEvents: .ValueChanged);
        marginSegment.addTarget(self, action: #selector(costViewController.action2), forControlEvents: .ValueChanged);
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    
    func action2() {
        if marginSegment.selectedSegmentIndex == 0 {
            marginTextField.borderStyle = UITextBorderStyle.RoundedRect
            profitTextField.borderStyle = UITextBorderStyle.None
        } else {
            profitTextField.borderStyle = UITextBorderStyle.RoundedRect
            marginTextField.borderStyle = UITextBorderStyle.None
        }
    }
    
    func action1() {
        if priceSegment.selectedSegmentIndex == 0 {
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
        
        if textField == profitTextField {
            marginSegment.selectedSegmentIndex = 1
            profitTextField.borderStyle = UITextBorderStyle.RoundedRect
            marginTextField.borderStyle = UITextBorderStyle.None
        }
        if textField == marginTextField {
            marginSegment.selectedSegmentIndex = 0
            marginTextField.borderStyle = UITextBorderStyle.RoundedRect
            profitTextField.borderStyle = UITextBorderStyle.None
        }
        
        if textField == incVATTextField {
            priceSegment.selectedSegmentIndex = 1
            incVATTextField.borderStyle = UITextBorderStyle.RoundedRect
            excVATTextField.borderStyle = UITextBorderStyle.None
        }
        if textField == excVATTextField {
            priceSegment.selectedSegmentIndex = 0
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
        
        if marginSegment.selectedSegmentIndex == 0 {
            
            let vat, excvat, margin: Float
            
            if let text = VATTextField.text {
                if let number = Float(text) {
                    vat = number
                } else {
                    vat = 0
                }
            } else {
                vat = 0
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
            
            if let text = marginTextField.text {
                if let number = Float(text) {
                    margin = number
                } else {
                    margin = 0
                }
            } else {
                margin = 0
            }
            
            let incvat = excvat+(excvat*vat/100.0)
            let profit = margin*excvat/100.0
            let cost = excvat-profit
            VATTextField.text = String(format: "%.02f", vat)
            costTextField.text = String(format: "%.02f", cost)
            marginTextField.text = String(format: "%.02f", margin)
            profitTextField.text = String(format: "%.02f", profit)
            excVATTextField.text = String(format: "%.02f", excvat)
            incVATTextField.text = String(format: "%.02f", incvat)
        } else {
            
            let vat, excvat, profit: Float
            
            if let text = VATTextField.text {
                if let number = Float(text) {
                    vat = number
                } else {
                    vat = 0
                }
            } else {
                vat = 0
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
            
            if let text = profitTextField.text {
                if let number = Float(text) {
                    profit = number
                } else {
                    profit = 0
                }
            } else {
                profit = 0
            }
            
            let incvat = excvat+(excvat*vat/100.0)
            let margin = profit*100.0/excvat
            let cost = excvat-profit
            VATTextField.text = String(format: "%.02f", vat)
            costTextField.text = String(format: "%.02f", cost)
            marginTextField.text = String(format: "%.02f", margin)
            profitTextField.text = String(format: "%.02f", profit)
            excVATTextField.text = String(format: "%.02f", excvat)
            incVATTextField.text = String(format: "%.02f", incvat)
        }
    }
    
    func calculateUsingIncVAT() {
        
        if marginSegment.selectedSegmentIndex == 0 {
            let vat = Float(VATTextField.text!)
            let incvat = Float(incVATTextField.text!)
            let margin = Float(marginTextField.text!)
            let excvat = incvat!*100.0/(100.0+vat!)
            let profit = margin!*excvat/100.0
            let cost = excvat-profit
            VATTextField.text = String(format: "%.02f", vat!)
            costTextField.text = String(format: "%.02f", cost)
            marginTextField.text = String(format: "%.02f", margin!)
            profitTextField.text = String(format: "%.02f", profit)
            excVATTextField.text = String(format: "%.02f", excvat)
            incVATTextField.text = String(format: "%.02f", incvat!)
        } else {
            let vat = Float(VATTextField.text!)
            let incvat = Float(incVATTextField.text!)
            let profit = Float(profitTextField.text!)
            let excvat = incvat!*100.0/(100.0+vat!)
            let margin = profit!*100.0/excvat
            let cost = excvat-profit!
            VATTextField.text = String(format: "%.02f", vat!)
            costTextField.text = String(format: "%.02f", cost)
            marginTextField.text = String(format: "%.02f", margin)
            profitTextField.text = String(format: "%.02f", profit!)
            excVATTextField.text = String(format: "%.02f", excvat)
            incVATTextField.text = String(format: "%.02f", incvat!)
        }
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
        //        costTextField.borderStyle = UITextBorderStyle.RoundedRect
        costTextField.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        self.view.addSubview(costTextField)
        
        marginTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        marginTextField.center = CGPointMake(marginSegment.center.x-marginSegment.frame.size.width/4, marginSegment.center.y+marginTextField.frame.height)
        marginTextField.keyboardType = UIKeyboardType.DecimalPad
        marginTextField.borderStyle = UITextBorderStyle.RoundedRect
        marginTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(marginTextField)
        
        profitTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        profitTextField.center = CGPointMake(marginSegment.center.x+marginSegment.frame.size.width/4, marginSegment.center.y+profitTextField.frame.height)
        profitTextField.keyboardType = UIKeyboardType.DecimalPad
        //        profitTextField.borderStyle = UITextBorderStyle.RoundedRect
        profitTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(profitTextField)
        
        excVATTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        excVATTextField.center = CGPointMake(priceSegment.center.x-priceSegment.frame.size.width/4, priceSegment.center.y+excVATTextField.frame.height)
        excVATTextField.keyboardType = UIKeyboardType.DecimalPad
        //        excVATTextField.borderStyle = UITextBorderStyle.RoundedRect
        excVATTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(excVATTextField)
        
        incVATTextField.frame = CGRectMake(0, 0, 100.0, 30.0)
        incVATTextField.center = CGPointMake(priceSegment.center.x+priceSegment.frame.size.width/4, priceSegment.center.y+incVATTextField.frame.height)
        incVATTextField.keyboardType = UIKeyboardType.DecimalPad
        incVATTextField.borderStyle = UITextBorderStyle.RoundedRect
        incVATTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(incVATTextField)
    }
    
    
    func setupLabels() {
        
        costLabel.frame = CGRectMake(0, 0, 150.0, 22.0)
        costLabel.center = CGPointMake(CGRectGetMidX(self.view.frame)-costLabel.frame.width/2, CGRectGetMidY(self.view.frame)+costLabel.frame.height)
        costLabel.textAlignment = NSTextAlignment.Right
        costLabel.text = "Cost :"
        self.view.addSubview(costLabel)
        
        // above center
        
        marginSegment.frame = CGRectMake(0, 0, 280.0, 25.0)
        marginSegment.center = CGPointMake(CGRectGetMidX(self.view.frame),costLabel.center.y-costLabel.frame.height*3.5)
        marginSegment.selectedSegmentIndex = 0
        self.view.addSubview(marginSegment)
        
        priceSegment.frame = CGRectMake(0, 0, 280.0, 25.0)
        priceSegment.center = CGPointMake(CGRectGetMidX(self.view.frame),marginSegment.center.y-marginSegment.frame.height*3)
        priceSegment.selectedSegmentIndex = 1
        self.view.addSubview(priceSegment)
        
        VATLabel.frame = costLabel.frame
        VATLabel.center = CGPointMake(costLabel.center.x,priceSegment.center.y-priceSegment.frame.height*2)
        VATLabel.textAlignment = NSTextAlignment.Right
        VATLabel.text = "VAT % :"
        self.view.addSubview(VATLabel)
        
        resetButton.frame = costLabel.frame
        resetButton.center = CGPointMake(resetButton.frame.size.width/3, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - resetButton.frame.size.height*2)
        resetButton.setTitle("Reset", forState: UIControlState.Normal)
//        resetButton.addTarget(self, action: "reset", forControlEvents: UIControlEvents.TouchUpInside)
        resetButton.addTarget(self, action: #selector(costViewController.reset), forControlEvents: UIControlEvents.TouchUpInside)
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

