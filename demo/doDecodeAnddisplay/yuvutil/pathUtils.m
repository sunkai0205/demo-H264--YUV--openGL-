//
//  pathUtils.m
//  demo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 zhaozheng. All rights reserved.
//

#import "pathUtils.h"

@implementation pathUtils


+ (NSString *) pathToYUVFileWithFileName:(NSString *)name
{
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *pName = name;
    
    if (name && ([name hasSuffix:@"yuv"] == NO))
    {
        pName = [NSString stringWithFormat:@"%@.yuv",name];
    }
    
    NSString *pathDirectory = [NSString stringWithFormat:@"%@/CachesYUV",tmpDir];
    NSString *path = [NSString stringWithFormat:@"%@/CachesYUV/%@",tmpDir,pName];
    NSFileManager* fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:pathDirectory])
    {
        [fm createDirectoryAtPath:pathDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

+ (BOOL) removeYUVFileWithFilePath:(NSString *)path
{
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!blHave) {
        return NO;
    }else {
        BOOL blDele= [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (blDele) {
            return YES;
        }else {
            return NO;
        }
    }
}


+ (NSString*) saveBufferData:(const void *)bytes length:(NSUInteger)length;
{
    NSData *data = [NSData dataWithBytes:bytes length:length];
    Byte byte[4] = {(Byte)0x00,(Byte)0x00,(Byte)0x00,(Byte)0x01};
    NSMutableData *resultData = [NSMutableData dataWithData:[NSData dataWithBytes:byte length:4]];
    [resultData appendData:data];
    
    if ([resultData length]==0 || !resultData) {
        return nil;
    }
    
    
    NSFileManager *fileMngr =[NSFileManager defaultManager];
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *pathDirectory = [NSString stringWithFormat:@"%@/CachesH264",tmpDir];

    if (![fileMngr fileExistsAtPath:pathDirectory]) {
        [fileMngr createDirectoryAtPath:pathDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    int y = (arc4random() % 1000000) + 1;

    NSString *videoName = [NSString stringWithFormat:@"REVideo_%i.264",y];
    NSString *videoPath = [pathDirectory stringByAppendingPathComponent:videoName];
    
    while ([fileMngr fileExistsAtPath:videoPath]) {
        videoName = [NSString stringWithFormat:@"REVideo_%i.264",y];
        videoPath = [pathDirectory stringByAppendingPathComponent:videoName];
    }
    
    if (![fileMngr fileExistsAtPath:videoPath]) {
        [fileMngr createFileAtPath:videoPath contents:nil attributes:nil];
    }
    
    NSFileHandle *handele = [NSFileHandle fileHandleForWritingAtPath:videoPath];
    [handele seekToEndOfFile];
    [handele writeData:resultData];
    [handele closeFile];
    
    return videoPath;
}

@end
