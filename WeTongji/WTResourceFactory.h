//
//  WTResourceFactory.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTResourceFactory : NSObject

+ (UIButton *)createNormalButtonWithText:(NSString *)text;

+ (UIButton *)createFocusButtonWithText:(NSString *)text;

@end
