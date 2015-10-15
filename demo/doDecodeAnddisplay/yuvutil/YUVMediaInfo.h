//
//  YUVMediaInfo.h
//  demo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 zhaozheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUVMediaInfo : NSObject

@property (nonatomic, assign) int           videoWidth;
@property (nonatomic, assign) int           videoHeigth;
@property (nonatomic, strong) NSString      *h264Path;
@property (nonatomic, strong) NSString      *YUVPath;
@property (nonatomic, assign) const void    *bytes;
@property (nonatomic, assign) NSUInteger    length;

@end
