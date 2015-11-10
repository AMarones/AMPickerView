//
//  MultiplesPickersViewController.swift
//  Sample
//
//  Created by Alexandre Marones on 11/10/15.
//
//

import UIKit

class MultiplesPickersViewController: UIViewController , AMPickerViewDelegate {
    
    @IBOutlet weak var buttonSelectValue:   UIButton!
    @IBOutlet weak var buttonSelectCard:    UIButton!
    
    private var _cards           = ["•••• 5858", "•••• 4444", "•••• 3269", "•••• 1109"]
    private var _values          = ["$10", "$20", "$35", "$60"]
    private var _datasource      = [String]()
    
    private let _sentByValues    = "values"
    private let _sentByCards     = "cards"
    private var _sentBy          = String()
    
    private var _alertPickerView = AMPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _alertPickerView = AMPickerView(delegate: self, ownerViewControler: self)
    }
    
    func showPickerView() {
        var pickerTitle = "Select Card"
        
        if _sentBy == _sentByValues {
            pickerTitle = "Select Value"
        }
        
        _alertPickerView.show(pickerTitle, datasource: _datasource)
    }
    
    
    
    // MARK: - IBAction
    
    @IBAction func selectValueButtonPressed(sender: AnyObject) {
        _datasource.removeAll(keepCapacity: false)
        _datasource = _values
        _sentBy = _sentByValues
        
        showPickerView()
    }
    
    @IBAction func selectCardButtonPressed(sender: AnyObject) {
        _datasource.removeAll(keepCapacity: false)
        _datasource = _cards
        _sentBy = _sentByCards
        
        showPickerView()
    }
    
    
    // MARK: - AMActionPickerViewDelegate
    
    func cancelButtonPressed() {
        _alertPickerView.close()
    }
    
    func doneButtonPressed(index: Int) {
        let selectedValue = _datasource[index]
        
        if _sentBy == _sentByValues {
            buttonSelectValue.setTitle(selectedValue, forState: UIControlState.Normal)
        } else {
            buttonSelectCard.setTitle(selectedValue, forState: UIControlState.Normal)
        }
        
        _alertPickerView.close()
    }
}
