//
//  pathUtils.h
//  demo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 zhaozheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pathUtils : NSObject

+ (NSString *) pathToYUVFileWithFileName:(NSString *)name;

+ (BOOL) removeYUVFileWithFilePath:(NSString *)path;

+ (NSString*) saveBufferData:(const void *)bytes length:(NSUInteger)length;

@end
