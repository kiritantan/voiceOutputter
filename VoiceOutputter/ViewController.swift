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
    @IBOutlet weak var takeImageButton: UIBarButtonItem!
    @IBOutlet weak var displayConvertedSentenceView: UITextView!
    @IBOutlet weak var displayVoiceOutputSentenceView: UITextView!
    @IBOutlet weak var controlVoiceSpeedSlider: UISlider!
    @IBOutlet weak var stopVoiceOutputButton: UIButton!

    var numberOfSentence:NSInteger = 0
    var indexOfSentence:NSInteger = 0
    var voiceOutput:voiceOutputModel = voiceOutputModel()
    var textModel:textViewModel = textViewModel()
    var viewModel:viewControllerModel = viewControllerModel()
    
    //MARK:view life cycele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfSentence = self.textModel.countNumberOfSentence(self.displayConvertedSentenceView.text)
    }

    //MARK:button's function
    
    @IBAction func didTapTakeImageButton(sender: AnyObject) {
        if (!(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))) {
            return
        }
        var imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
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

    //MARK:UIImagePickerViewDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.displayTakenImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2+75)
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        spinner.startAnimating()
        dispatch_async(dispatch_get_main_queue(), {
            var tesseractOCR:tesseractOCRiOS = tesseractOCRiOS()
            self.displayConvertedSentenceView.text = tesseractOCR.getConvertStringWithImage(self.displayTakenImageView.image)
            self.displayVoiceOutputSentenceView.text = self.textModel.getStringOfIndex(self.indexOfSentence, sentences: self.displayConvertedSentenceView.text)
            self.numberOfSentence = self.textModel.countNumberOfSentence(self.displayConvertedSentenceView.text)
            spinner.stopAnimating()
            })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


