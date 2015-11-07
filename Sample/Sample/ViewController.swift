//
//  ViewController.swift
//  Sample
//
//  Created by Alexandre Marones on 19/08/15.
//
//

import UIKit

class ViewController: UIViewController, AMPickerViewDelegate {

    @IBOutlet weak var buttonSelectValue: UIButton!
    @IBOutlet weak var buttonSelectCard: UIButton!
    
    private var cards = ["•••• 5858", "•••• 4444", "•••• 3269", "•••• 1109"]
    private var values = ["$10", "$20", "$35", "$60"]
    private var datasource = [String]()
    
    private let sentByValues = "values"
    private let sentByCards = "cards"
    private var sentBy = String()
    
    private var alertPickerView = AMPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPickerView() {
        alertPickerView = AMPickerView(delegate: self, datasource: datasource, ownerViewControler: self)
        
        var pickerTitle = "Select Card"
        
        if sentBy == sentByValues {
            pickerTitle = "Select Value"
        }
        
        alertPickerView.topBarTitle = pickerTitle
        
        alertPickerView.show()
    }


    
    // MARK: - IBAction
    
    @IBAction func selectValueButtonPressed(sender: AnyObject) {
        datasource.removeAll(keepCapacity: false)
        datasource = values
        sentBy = sentByValues
        
        showPickerView()
    }
    
    @IBAction func selectCardButtonPressed(sender: AnyObject) {
        datasource.removeAll(keepCapacity: false)
        datasource = cards
        sentBy = sentByCards
        
        showPickerView()
    }
    
    
    // MARK: - AMActionPickerViewDelegate
    
    func cancelButtonPressed() {
        alertPickerView.close()
    }
    
    func doneButtonPressed(index: Int) {
        let selectedValue = datasource[index]
        
        if sentBy == sentByValues {
            buttonSelectValue.setTitle(selectedValue, forState: UIControlState.Normal)
        } else {
            buttonSelectCard.setTitle(selectedValue, forState: UIControlState.Normal)
        }
        
        alertPickerView.close()
    }
}

