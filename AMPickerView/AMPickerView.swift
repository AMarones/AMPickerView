//
//  AMActionPickerView.swift
//  AMActionPickerView.swift
//
//  Created by Alexandre Marones on 18/08/15.
//  Copyright (c) 2015 Alexandre Marones. All rights reserved.
//

import UIKit

protocol AMPickerViewDelegate {
    func cancelButtonPressed()
    func doneButtonPressed(index: Int)
}

class AMPickerView: NSObject {
    
    
    // MARK: - Private properties
    
    private let _screenSize = UIScreen.mainScreen().bounds.size
    
    private var _selectedIndex: Int = 0
    
    /// Title for done button
    private var _doneButtonTitle = "Done"
    
    /// The color used for done button title
    private var _doneButtonTitleColor = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1.0)
    
    /// The color used for done button highlighted
    private var _doneButtonHighlightedTitleColor = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 0.5)
    
    /// Font name used for done button title
    private var _doneButtonFontName = "Helvetica"
    
    /// Title for cancel button
    private var _cancelButtonTitle = "Cancel"
    
    /// The color used for cancel button title
    private var _cancelButtonTitleColor = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1.0)
    
    /// The color used for cancel button highlighted
    private var _cancelButtonHighlightedTitleColor = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 0.5)
    
    /// Font name used for cancel button title
    private var _cancelButtonFontName = "Helvetica"
    
    /// The color used in picker text row in list
    private var _pickerTextColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
    
    /// Font name used for picker text row in list
    private var _pickerTextFontName = "Helvetica"
    
    /// Title in top bar view
    private var _topBarTitle = "Title"
    
    /// Font name used for title in top bar view
    private var _topBarViewTextFontName = "Helvetica"
    
    /// Toolbar view background color
    private var _topBarViewBackgroundColor = UIColor(red: 23/255, green: 128/255, blue: 210/255, alpha: 1.0)
    
    /// Intern usage
    private let _alertTitle = ""
    
    /// Intern usage
    private let _alertMessage = "\n\n\n\n\n\n\n\n\n\n"
    
    /// Alert Picker
    private var _alertPicker: UIAlertController?
    
    /// Title Label
    private var _titleLabel: UILabel?
    
    /// Datasource
    private var _datasource = [String]()
    
    /// The parent (owner) view controller
    private var ownerViewControler: UIViewController!
    
    
    // MARK: - Public properties
    
    var delegate: AMPickerViewDelegate!
    
    
    var topBarViewBackgroundColor: UIColor {
        get  {
            return _topBarViewBackgroundColor
        }
        
        set {
            _topBarViewBackgroundColor = newValue
        }
    }
    
    var topBarViewTextFontName: String {
        get  {
            return _topBarViewTextFontName
        }
        
        set {
            _topBarViewTextFontName = newValue
        }
    }
    
    var topBarTitle: String {
        get  {
            return _topBarTitle
        }
        
        set {
            _topBarTitle = newValue
        }
    }
    
    var doneButtonTitle: String {
        get  {
            return _doneButtonTitle
        }
        
        set {
            _doneButtonTitle = newValue
        }
    }
    
    var cancelButtonTitle: String {
        get  {
            return _cancelButtonTitle
        }
        
        set {
            _cancelButtonTitle = newValue
        }
    }
    
    var pickerTextFontName: String {
        get  {
            return _pickerTextFontName
        }
        
        set {
            _pickerTextFontName = newValue
        }
    }
    
    var doneButtonFontName: String {
        get  {
            return _doneButtonFontName
        }
        
        set {
            _doneButtonFontName = newValue
        }
    }
    
    var cancelButtonFontName: String {
        get  {
            return _cancelButtonFontName
        }
        
        set {
            _cancelButtonFontName = newValue
        }
    }
    
    var pickerTextColor: UIColor {
        get  {
            return _pickerTextColor
        }
        
        set {
            _pickerTextColor = newValue
        }
    }
    
    convenience init(delegate: AMPickerViewDelegate, ownerViewControler: UIViewController) {
        self.init()
        
        self.delegate = delegate
        self.ownerViewControler = ownerViewControler
        
        setupActionPicker()
    }
    
    convenience init(delegate: AMPickerViewDelegate, title: String, datasource: [String], ownerViewControler: UIViewController) {
        self.init()
        
        self.delegate = delegate
        self.topBarTitle = title
        self.ownerViewControler = ownerViewControler
        _datasource = datasource
        
        setupActionPicker()
    }
    
    private func setupActionPicker() {
        _alertPicker = UIAlertController(title: _alertTitle, message: _alertMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        _alertPicker!.modalInPopover = true
        
        var widthWithMargin = _screenSize.width - 16
        
        if #available(iOS 9.0, *) {
            widthWithMargin = _screenSize.width - 20
        }
        
        // Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRectMake(0, 40, widthWithMargin, 170) // CGRectMake(left), top, width, height) - left and top are like margins
        let pickerView  = UIPickerView(frame: pickerFrame)
        
        // set the pickers datasource and delegate
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Add the picker to the alert controller
        _alertPicker!.view.addSubview(pickerView)
        
        NSFoundationVersionNumber_iOS_8_0
        
        //Create the toolbar view - the view witch will hold our 2 buttons
        let toolFrame = CGRectMake(0, 0, widthWithMargin, 40)
        let toolView: UIView = UIView(frame: toolFrame)
        toolView.backgroundColor = topBarViewBackgroundColor
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: toolFrame, byRoundingCorners: [UIRectCorner.TopRight, UIRectCorner.TopLeft], cornerRadii: CGSize(width: 3, height: 3)).CGPath
        toolView.layer.mask = maskLayer
        
        let titleFrame: CGRect = CGRectMake(16, 0, 100, 40) // CGRectMake(left), top, width, height) - left and top are like margins
        _titleLabel = UILabel(frame: titleFrame)
        
        setupTitleLabel()
        
        //add the toolbar to the alert controller
        toolView.addSubview(_titleLabel!)
        toolView.addSubview(buildCancelButton())
        toolView.addSubview(buildDoneButton())
        
        _alertPicker!.view.addSubview(toolView)
    }
    
    private func setupTitleLabel() {
        let title = NSAttributedString(string: topBarTitle, attributes: [NSFontAttributeName:UIFont(name: topBarViewTextFontName, size: 16.0)!, NSForegroundColorAttributeName:UIColor.whiteColor()])
        _titleLabel!.attributedText = title
    }
    
    private func buildCancelButton() -> UIButton {
        let cancelButtonFrame: CGRect = CGRectMake(_screenSize.width - 190, 0, 100, 40)
        let cancelButton: UIButton = UIButton(frame: cancelButtonFrame)
        let cancelTitle = NSAttributedString(string: cancelButtonTitle, attributes: [NSFontAttributeName:UIFont(name: self.cancelButtonFontName, size: 16.0)!, NSForegroundColorAttributeName:_cancelButtonTitleColor])
        let cancelButtonTitleHighlighted = NSAttributedString(string: self.cancelButtonTitle, attributes: [NSFontAttributeName:UIFont(name: _cancelButtonFontName, size: 16.0)!, NSForegroundColorAttributeName:_doneButtonHighlightedTitleColor])
        
        cancelButton.setAttributedTitle(cancelTitle, forState: UIControlState.Normal)
        cancelButton.setAttributedTitle(cancelButtonTitleHighlighted, forState: UIControlState.Highlighted)
        
        cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cancelButton
    }
    
    private func buildDoneButton() -> UIButton {
        let doneButtonFrame: CGRect = CGRectMake(_screenSize.width - 100, 0, 80, 40)
        let doneButton: UIButton = UIButton(frame: doneButtonFrame)
        let doneTitle = NSAttributedString(string: doneButtonTitle, attributes: [NSFontAttributeName:UIFont(name: doneButtonFontName, size: 16.0)!, NSForegroundColorAttributeName:_doneButtonTitleColor])
        let doneButtonTitleHighlighted = NSAttributedString(string: doneButtonTitle, attributes: [NSFontAttributeName:UIFont(name: doneButtonFontName, size: 16.0)!, NSForegroundColorAttributeName:_doneButtonHighlightedTitleColor])
        
        doneButton.setAttributedTitle(doneTitle, forState: UIControlState.Normal)
        doneButton.setAttributedTitle(doneButtonTitleHighlighted, forState: UIControlState.Highlighted)
        
        doneButton.addTarget(self, action: "doneAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return doneButton
    }
    
    func show(title: String, datasource: [String]) {
        topBarTitle = title
        _datasource.removeAll(keepCapacity: false)
        _datasource = datasource
        
        setupTitleLabel()
        
        ownerViewControler.presentViewController(_alertPicker!, animated: true, completion: nil)
    }
    
    func show() {
        ownerViewControler.presentViewController(_alertPicker!, animated: true, completion: nil)
    }
    
    func close() {
        ownerViewControler.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelAction(sender: UIButton) {
        delegate.cancelButtonPressed()
    }
    
    func doneAction(sender: UIButton) {
        delegate.doneButtonPressed(_selectedIndex)
    }
}


// MARK: - UIPickerViewDataSource

extension AMPickerView: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _datasource.count
    }
}


// MARK: - UIPickerViewDelegate

extension AMPickerView: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = _datasource[row]
        
        let myTitle = NSAttributedString(string: titleData.uppercaseString, attributes: [NSFontAttributeName:UIFont(name: pickerTextFontName, size: 18.0)!, NSForegroundColorAttributeName:pickerTextColor])
        
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _selectedIndex = row
    }
}
