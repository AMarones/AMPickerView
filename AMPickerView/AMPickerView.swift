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
    
    
    // MARK: - Intern usage
    
    private let _alertTitle             = ""
    private let _alertMessage           = "\n\n\n\n\n\n\n\n\n\n"
    private var _selectedIndex: Int     = 0
    private let _screenSize             = UIScreen.mainScreen().bounds.size
    

    // MARK: - Private properties
    
    private var _alertPicker:           UIAlertController?
    private var _titleLabel:            UILabel?
    private var _pickerView:            UIPickerView?
    private var _ownerViewControler:    UIViewController!
    private var _delegate:              AMPickerViewDelegate!
    private var _datasource             = [String]()
    
    
    // MARK: - Custom Titles
    
    private var _doneButtonTitle            = "Done"
    private var _topBarTitle                = "Title"
    private var _cancelButtonTitle          = "Cancel"
    
    
    // MARK: - Custom FontNames
    
    private var _doneButtonFontName         = "Helvetica"
    private var _cancelButtonFontName       = "Helvetica"
    private var _pickerTextFontName         = "Helvetica"
    private var _topBarViewTextFontName     = "Helvetica"
    
    
    // MARK: - Custom Colors
    
    private var _doneButtonTitleColor               = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1.0)
    private var _doneButtonHighlightedTitleColor    = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 0.5)
    private var _cancelButtonTitleColor             = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1.0)
    private var _cancelButtonHighlightedTitleColor  = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 0.5)
    private var _pickerTextColor                    = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
    private var _topBarViewBackgroundColor          = UIColor(red: 23/255, green: 128/255, blue: 210/255, alpha: 1.0)
    
    
    // MARK: - Setup Custom Layout
    
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
    
    
    // MARK: - Imp
    
    // Use this for dynamic titles and datasources
    convenience init(delegate: AMPickerViewDelegate, ownerViewControler: UIViewController) {
        self.init()
        
        _delegate = delegate
        _ownerViewControler = ownerViewControler
        
        setupActionPicker()
    }
    
    // Use this for single title and datasources
    convenience init(delegate: AMPickerViewDelegate, title: String, datasource: [String], ownerViewControler: UIViewController) {
        self.init()
        
        topBarTitle = title
        
        _delegate = delegate
        _ownerViewControler = ownerViewControler
        _datasource = datasource
        
        setupActionPicker()
    }
    
    
    // MARK: - Private Methods
    
    private func setupActionPicker() {
        _alertPicker = UIAlertController(title: _alertTitle, message: _alertMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        _alertPicker!.modalInPopover = true
        
        var widthWithMargin = _screenSize.width - 16
        
        if #available(iOS 9.0, *) {
            widthWithMargin = _screenSize.width - 20
        }
        
        // Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRectMake(0, 40, widthWithMargin, 170) // CGRectMake(left), top, width, height) - left and top are like margins
        _pickerView  = UIPickerView(frame: pickerFrame)
        
        // set the pickers datasource and delegate
        _pickerView!.delegate = self
        _pickerView!.dataSource = self
        
        // Add the picker to the alert controller
        _alertPicker!.view.addSubview(_pickerView!)
        
        NSFoundationVersionNumber_iOS_8_0
        
        // Create the toolbar view - the view witch will hold our 2 buttons
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
        let cancelButtonTitleHighlighted = NSAttributedString(string: cancelButtonTitle, attributes: [NSFontAttributeName:UIFont(name: _cancelButtonFontName, size: 16.0)!, NSForegroundColorAttributeName:_doneButtonHighlightedTitleColor])
        
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
    
    
    // MARK: - Public Methods
    
    func show(title: String, datasource: [String]) {
        topBarTitle = title
        _datasource.removeAll(keepCapacity: false)
        _datasource = datasource
        
        setupTitleLabel()
        
        _ownerViewControler.presentViewController(_alertPicker!, animated: true, completion: nil)
    }
    
    func show() {
        _ownerViewControler.presentViewController(_alertPicker!, animated: true, completion: nil)
    }
    
    func close() {
        _ownerViewControler.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - AMPrickerView Actions
    
    func cancelAction(sender: UIButton) {
        _delegate.cancelButtonPressed()
    }
    
    func doneAction(sender: UIButton) {
        _delegate.doneButtonPressed(_selectedIndex)
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
