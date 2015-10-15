//
//  DecodeH264DisplayManager.m
//  demo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 zhaozheng. All rights reserved.
//

#import "DecodeH264DisplayManager.h"
#import "pathUtils.h"
#import "OpenGLYUV420P.h"
#import "YUVObj.h"
#import "YUVMediaInfo.h"
#import "pathUtils.h"

extern int DecMain(int argc, char * argv[]);


@interface DecodeH264DisplayManager()<YUVObjDelegate>
{
    NSOperationQueue *decoderoOperationQueue;
    NSOperationQueue *disPlayOperationQueue;
    YUVObj           *obj;
}
@property (strong, nonatomic) OpenGLYUV420P  *displayView;

@end


@implementation DecodeH264DisplayManager
@synthesize displayView;

#pragma mark -
#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        decoderoOperationQueue = [[NSOperationQueue alloc] init]; //初始化操作队列
        [decoderoOperationQueue setMaxConcurrentOperationCount:1];
        
        disPlayOperationQueue = [[NSOperationQueue alloc] init]; //初始化操作队列
        [disPlayOperationQueue setMaxConcurrentOperationCount:1];
        
        obj = [[YUVObj alloc]init];
        [obj setDelegate:self];
        
    }
    return self;
}


#pragma mark -
#pragma mark - 对外接口
- (UIView*)displayView:(CGRect)frame
{
    self.displayView = [[OpenGLYUV420P alloc]initWithFrame:frame];
    return self.displayView;
}

- (void) DoDecoderWithH264Data:(const void *)bytes length:(NSUInteger)length videoWidth:(int)width videoHeigth:(int)heigth
{
    if (self.displayView) {
        [self.displayView inputResolutionWidth:width height:heigth];
    }
    
    
    YUVMediaInfo *mediaInfo = [[YUVMediaInfo alloc]init];
    mediaInfo.videoHeigth = heigth;
    mediaInfo.videoWidth  = width;
    mediaInfo.length      = length;
    mediaInfo.bytes       = bytes;
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                        selector:@selector(doWork:) object:mediaInfo];
    [decoderoOperationQueue addOperation:theOp];
    
}

- (void) stopDisplay
{
    [decoderoOperationQueue cancelAllOperations];
    [disPlayOperationQueue cancelAllOperations];
}
#pragma mark -
#pragma mark - do decode
- (void)doWork:(YUVMediaInfo*)mediaInfo
{
    
    NSString *h264Path = [pathUtils saveBufferData:mediaInfo.bytes length:mediaInfo.length];
    
    NSString *fileName = [h264Path lastPathComponent];
    NSString *outputFileName = [[fileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"yuv"];
    
    NSString *outputFilePath = [pathUtils pathToYUVFileWithFileName:outputFileName];
                                
    mediaInfo.h264Path = h264Path;
    mediaInfo.YUVPath  = outputFilePath;
        
    if(mediaInfo.YUVPath == nil)
    {
        return;
    }
                                
    char *argv[3];
    int  argc = 3;
    
    argv[0] = (char *)("decConsole.exe");
    argv[1] = (char *)[mediaInfo.h264Path UTF8String];
    argv[2] = (char *)[mediaInfo.YUVPath UTF8String];
    
    DecMain(argc, argv);
    
    
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                                                                        selector:@selector(displayYUV:) object:mediaInfo];
    [disPlayOperationQueue addOperation:theOp];
    
    [pathUtils removeYUVFileWithFilePath:mediaInfo.h264Path];
}

#pragma mark -
#pragma mark - display
- (void)displayYUV:(YUVMediaInfo*)mediaInfo
{
    [obj readYUV:mediaInfo.YUVPath mediaInfo:mediaInfo];
}
#pragma mark -
#pragma mark - YUVObj Delegate
- (void)didFinishWithData:(NSData*)spaces mediaInfo:(YUVMediaInfo *)info isEnd:(BOOL)isEnd
{
    if (self.displayView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (spaces) {
                UInt8 * pFrameRGB = (UInt8*)[spaces bytes];
                [self.displayView inputActualYUVData:pFrameRGB width:info.videoWidth height:info.videoHeigth];
            }
            
            if (isEnd) {
                [pathUtils removeYUVFileWithFilePath:info.YUVPath];
            }
            
        });
    }    
}
@end
