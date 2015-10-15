//
//  YUVObj.h
//  YUVToImage
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUVMediaInfo.h"

@protocol YUVObjDelegate <NSObject>

@optional
- (void)didFinishWithData:(NSData*)spaces mediaInfo:(YUVMediaInfo *)info isEnd:(BOOL)isEnd;
@end


@interface YUVObj : NSObject

- (void)readYUV:(NSString*)path mediaInfo:(YUVMediaInfo *)info;

- (void)cancel;

@property (nonatomic, assign) id<YUVObjDelegate> delegate;

@end
