//
//  voiceOutputModel.swift
//  VoiceOutputter
//
//  Created by syunichi on 2015/01/30.
//  Copyright (c) 2015年 University of Tsukuba. All rights reserved.
//

import UIKit
import AVFoundation

class voiceOutputModel: NSObject {
    var speaker:AVSpeechSynthesizer = AVSpeechSynthesizer()
    var utterance:AVSpeechUtterance = AVSpeechUtterance()

    func readSentence(indexOfSentence:NSInteger,numberOfSentence:NSInteger,sentence:String,voiceSpeedRate:Float) -> NSInteger {
        if(!speaker.paused && !speaker.speaking){
            self.utterance = AVSpeechUtterance(string:sentence)
            self.utterance.rate = voiceSpeedRate
            self.utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            self.speaker.speakUtterance(self.utterance)
            return (indexOfSentence < numberOfSentence) ? indexOfSentence+1 : 0
        }
        return indexOfSentence
    }
    
    func stopReadingSentence() {
        (speaker.paused) ? speaker.continueSpeaking() : speaker.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    func getStopVoiceOutputButtonImageName() -> String {
        return (!speaker.paused && speaker.speaking) ? "restart" : "stop"
    }
    
}
