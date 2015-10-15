
//
//  OpenGLYUV420P.h
//  YUVToImage
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>

@interface OpenGLYUV420P : UIView


- (void)inputActualYUVData:(void *)data width:(GLsizei)width height:(GLsizei)height;

- (void)inputResolutionWidth:(GLuint)width height:(GLuint)height;

- (void)clearUIView;

@end
