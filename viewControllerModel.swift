//
//  viewControllerModel.swift
//  VoiceOutputter
//
//  Created by syunichi on 2015/01/30.
//  Copyright (c) 2015年 University of Tsukuba. All rights reserved.
//

import UIKit

class viewControllerModel: NSObject {
    
    func advanceIndexOfSentence(indexOfSentence:NSInteger,numberOfSentence:NSInteger) -> NSInteger {
        return (indexOfSentence < numberOfSentence-1) ? indexOfSentence+1 : 0
    }
    
    func returnIndexOfSentence(indexOfSentence:NSInteger,numberOfSentence:NSInteger) -> NSInteger {
        return (indexOfSentence > 0 ) ? indexOfSentence-1 : numberOfSentence-1
    }
 }
