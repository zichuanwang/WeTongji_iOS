//
//  WTCategoryNewsViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsViewController.h"

@interface WTCategoryNewsViewController : WTNewsViewController

+ (WTCategoryNewsViewController *)createViewControllerWithNewsCategory:(NSNumber *)category;

@end
