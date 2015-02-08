//
//  tesseractOCRiOS.m
//  VoiceOutputter
//
//  Created by syunichi on 2015/02/06.
//  Copyright (c) 2015年 University of Tsukuba. All rights reserved.
//

#import "tesseractOCRiOS.h"
#import "tesseract.h"

@implementation tesseractOCRiOS
- (NSString *)getConvertStringWithImage:(id)selectedImage {
    __block NSString *convertString;
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"jpn"];
    [tesseract setImage:(UIImage *)selectedImage];
    [tesseract recognize];
    convertString = [tesseract recognizedText];
    return convertString;
}
@end
