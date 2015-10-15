//
//  DecodeH264DisplayManager.h
//  demo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 zhaozheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DecodeH264DisplayManager : NSObject

- (UIView*) displayView:(CGRect)frame;//宽高要和视频宽高成比例

- (void) DoDecoderWithH264Data:(const void *)bytes length:(NSUInteger)length videoWidth:(int)width videoHeigth:(int)heigth;

- (void) stopDisplay;
@end
