//
//  textViewModel.swift
//  VoiceOutputter
//
//  Created by syunichi on 2015/01/30.
//  Copyright (c) 2015年 University of Tsukuba. All rights reserved.
//

import UIKit

class textViewModel: NSObject {
    
    func countNumberOfSentence(sentences:String)->Int {
        if (sentences.isEmpty) {
            return 0
        } else {
            var count:Int = 1
            let chars = sentences.characters.map { String($0) }
            for char in chars {
                count += (char == "。") ? 1 : 0
            }
            return count
        }
    }
    
    func getStringOfIndex(index:Int,sentences:String)->String {
        if sentences.isEmpty {
            return ""
        } else {
            var count = 0
            var composition = String()
            let chars = sentences.characters.map { String($0) }
            for char in chars {
                if (char != "。") {
                    composition += String(char)
                } else {
                    if (count < index) {
                        composition = String()
                        count++
                    } else {
                        break
                    }
                }
            }
            return composition
        }
    }
}
