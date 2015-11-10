//
//  SinglePickerViewController.swift
//  Sample
//
//  Created by Alexandre Marones on 11/10/15.
//
//

import UIKit

class SinglePickerViewController: UIViewController, AMPickerViewDelegate {

    
    @IBOutlet weak var buttonSelectCard:    UIButton!
    
    private let _datasource          = ["•••• 5858", "•••• 4444", "•••• 3269", "•••• 1109"]
    private let _titlePickerView     = "Select Card"
    
    private var _alertPickerView     = AMPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _alertPickerView = AMPickerView(delegate: self, title: _titlePickerView, datasource: _datasource, ownerViewControler: self)
    }

    
    // MARK: - IBAction
    
    @IBAction func selectCardButtonPressed(sender: AnyObject) {
        _alertPickerView.show()
    }

    
    // MARK: - AMActionPickerViewDelegate
    
    func cancelButtonPressed() {
        _alertPickerView.close()
    }
    
    func doneButtonPressed(index: Int) {
        let selectedValue = _datasource[index]
        
        buttonSelectCard.setTitle(selectedValue, forState: UIControlState.Normal)
        
        _alertPickerView.close()
    }
}
