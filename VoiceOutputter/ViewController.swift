//
//  ViewController.swift
//  VoiceOutputter
//
//  Created by takayuki abe on 2015/01/30.
//  Copyright (c) 2015年 University of Tsukuba. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var displayTakenImageView: UIImageView!
    @IBOutlet weak var displayConvertedSentenceView: UITextView!
    @IBOutlet weak var displayVoiceOutputSentenceView: UITextView!
    @IBOutlet weak var controlVoiceSpeedSlider: UISlider!
    @IBOutlet weak var stopVoiceOutputButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var toolbar: UIToolbar!
    
    var numberOfSentence:NSInteger = 0
    var indexOfSentence:NSInteger = 0
    var voiceOutput:voiceOutputModel = voiceOutputModel()
    var textModel:textViewModel = textViewModel()
    var viewModel:viewControllerModel = viewControllerModel()
    var languageSegmentedControl: UISegmentedControl!
    let ud = NSUserDefaults.standardUserDefaults()
    var isCaptured = false
    var isConverted = false
    
    //MARK:view life cycele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTollBar()
    }
    
    func initTollBar() {
        ud.registerDefaults(["language":0])
        numberOfSentence = self.textModel.countNumberOfSentence(self.displayConvertedSentenceView.text)
        let imagePickerButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "didTapTakeImageButton:")
        imagePickerButton.width = 30
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        languageSegmentedControl = UISegmentedControl(items: ["日本語","英語"])
        languageSegmentedControl.selectedSegmentIndex = ud.integerForKey("language")
        languageSegmentedControl.addTarget(self, action: "langiageChanged:", forControlEvents: .ValueChanged)
        for seg in 0..<2 {
            languageSegmentedControl.setWidth(250, forSegmentAtIndex: seg)
        }
        let languageSegmentedControlBarButtonItem = UIBarButtonItem(customView: languageSegmentedControl)
        let cameraRollButton = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: "didTapCameraRollButton:")
        cameraRollButton.width = 30
        toolbar.items = [imagePickerButton,spacer,languageSegmentedControlBarButtonItem,spacer,cameraRollButton]
    }

    //MARK:button's function
    
    func didTapTakeImageButton(sender: UIBarButtonItem) {
        if (!(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))) {
            return
        }
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func didTapCameraRollButton(senderrrrrr: UIBarButtonItem) {
        print("hoge")
    }
    
    @IBAction func didTapStartVoiceOutputButton(sender: AnyObject) {
        voiceOutput.readSentence(indexOfSentence, numberOfSentence: numberOfSentence, sentence: textModel.getStringOfIndex(indexOfSentence, sentences: displayVoiceOutputSentenceView.text), voiceSpeedRate: controlVoiceSpeedSlider.value)
    }
    
    @IBAction func didTapSNextSentenceButton(sender: AnyObject) {
        indexOfSentence = viewModel.advanceIndexOfSentence(indexOfSentence, numberOfSentence: numberOfSentence)
        displayVoiceOutputSentenceView.text = textModel.getStringOfIndex(self.indexOfSentence, sentences: self.displayConvertedSentenceView.text)
    }
    
    @IBAction func didTapReturnSentenceButton(sender: AnyObject) {
        indexOfSentence = viewModel.returnIndexOfSentence(indexOfSentence, numberOfSentence: numberOfSentence)
        displayVoiceOutputSentenceView.text = textModel.getStringOfIndex(self.indexOfSentence, sentences: self.displayConvertedSentenceView.text)
    }
    
    @IBAction func didTapUpVoiceSpeedButton(sender: AnyObject) {
        if (controlVoiceSpeedSlider.value<=controlVoiceSpeedSlider.maximumValue-0.05) {
            controlVoiceSpeedSlider.value += 0.05
        } else {
            controlVoiceSpeedSlider.value = controlVoiceSpeedSlider.maximumValue
        }
    }
    
    @IBAction func didTapDownVoiceSpeedButtonsender(sender: AnyObject) {
        if (controlVoiceSpeedSlider.value>=controlVoiceSpeedSlider.minimumValue+0.05) {
            controlVoiceSpeedSlider.value -= 0.05
        } else {
            controlVoiceSpeedSlider.value = controlVoiceSpeedSlider.minimumValue
        }
    }
    
    @IBAction func didTapStopVoiceOutputButton(sender: AnyObject) {
        stopVoiceOutputButton.setImage(UIImage(named:voiceOutput.getStopVoiceOutputButtonImageName()), forState: .Normal)
        voiceOutput.stopReadingSentence()
    }
    
    func langiageChanged(sender: UISegmentedControl) {
        ud.setInteger(sender.selectedSegmentIndex, forKey: "language")
        if isCaptured && !isConverted {
            spinner.startAnimating()
            isConverted = true
            dispatch_async(dispatch_get_main_queue(), {
                let tesseractOCR:tesseractOCRiOS = tesseractOCRiOS()
                var language = "jpn"
                if self.ud.integerForKey("language") == 1 {
                    language = "eng"
                }
                self.displayConvertedSentenceView.text = tesseractOCR.getConvertStringWithImage(self.displayTakenImageView.image, language: language)
                self.displayVoiceOutputSentenceView.text = self.textModel.getStringOfIndex(self.indexOfSentence, sentences: self.displayConvertedSentenceView.text)
                self.numberOfSentence = self.textModel.countNumberOfSentence(self.displayConvertedSentenceView.text)
                self.spinner.stopAnimating()
                self.isConverted = false
            })
        }
    }
    
    

    //MARK:UIImagePickerViewDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.displayTakenImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        spinner.startAnimating()
        isConverted = true
        dispatch_async(dispatch_get_main_queue(), {
            let tesseractOCR:tesseractOCRiOS = tesseractOCRiOS()
            var language = "jpn"
            if self.ud.integerForKey("language") == 1 {
                language = "eng"
            }
            self.displayConvertedSentenceView.text = tesseractOCR.getConvertStringWithImage(self.displayTakenImageView.image, language: language)
            self.displayVoiceOutputSentenceView.text = self.textModel.getStringOfIndex(self.indexOfSentence, sentences: self.displayConvertedSentenceView.text)
            self.numberOfSentence = self.textModel.countNumberOfSentence(self.displayConvertedSentenceView.text)
            self.isCaptured = true
            self.spinner.stopAnimating()
            self.isConverted = false
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


