//
//  YUVObj.m
//  YUVToImage
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "YUVObj.h"
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>
#include "sys/stat.h"

@interface YUVObj()
{
    BOOL             isCancel;
}
@property (nonatomic, strong) YUVMediaInfo *mediaInfo;
@end

@implementation YUVObj
@synthesize mediaInfo;

- (instancetype)init
{
    self = [super init];
    if (self) {
        isCancel = NO;
    }
    return self;
}

- (void)readYUV:(NSString*)path mediaInfo:(YUVMediaInfo *)info
{
    @autoreleasepool {
        
        self.mediaInfo = info;

        isCancel = NO;
        
        long long dataSize = [self fileSizeAtPath:path];
        
        unsigned char *space = (unsigned char *)malloc(self.mediaInfo.videoWidth*self.mediaInfo.videoHeigth*3/2);
        
        char *pImage = (char *)[path UTF8String];
        
        NSInteger offest = 0;
        
        do {
            
            if (isCancel) {
                if ([_delegate respondsToSelector:@selector(didFinishWithData:mediaInfo:isEnd:)]) {
                    [_delegate didFinishWithData:nil mediaInfo:self.mediaInfo isEnd:YES];
                }
                break;
            }
            
            [self ReadImage:space :pImage :self.mediaInfo.videoWidth :self.mediaInfo.videoHeigth*3/2 :offest];
            
            NSData *data = [NSData dataWithBytes:space length:self.mediaInfo.videoWidth*self.mediaInfo.videoHeigth*1.5];

            if ([_delegate respondsToSelector:@selector(didFinishWithData:mediaInfo:isEnd:)]) {
                [_delegate didFinishWithData:data mediaInfo:self.mediaInfo isEnd:NO];
            }
            
            offest = offest + self.mediaInfo.videoWidth*self.mediaInfo.videoHeigth*1.5;
            
        } while (offest < dataSize);
    
        free(space);
            
        if ([_delegate respondsToSelector:@selector(didFinishWithData:mediaInfo:isEnd:)]) {
            [_delegate didFinishWithData:nil mediaInfo:self.mediaInfo isEnd:YES];
        }
    }
}

- (void)cancel
{
    isCancel = YES;
}

#pragma mark - private

- (void) ReadImage:(unsigned char *)pImage :(char *)cFileName :(int) nWidth :(int)nHeight :(long )offset
{
    int j,i;
    unsigned char *pWork;
    FILE *fp=0;
    
    fp = fopen(cFileName,"rb" );
    
    if (fp)   //打开一幅图像
    {
       fseek(fp,offset,SEEK_SET);   //文件定位
        pWork=pImage; //指针指向
        for ( j=0;j<nHeight;j++,pWork+=nWidth )
            for ( i=0;i<nWidth;i++ )
            {
                fread(pWork+i,1,1,fp); //顺序读取
            }
        
        fclose(fp);
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

@end


