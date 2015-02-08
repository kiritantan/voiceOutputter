//
//  tesseractOCRiOS.h
//  VoiceOutputter
//
//  Created by syunichi on 2015/02/06.
//  Copyright (c) 2015年 University of Tsukuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tesseractOCRiOS : NSObject
- (NSString *)getConvertStringWithImage:(id)selectedImage;
@end
