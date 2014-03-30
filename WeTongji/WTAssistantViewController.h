//
//  WTAssistantViewController.h
//  WeTongji
//
//  Created by Tom Hu on 13-10-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootViewController.h"

typedef enum {
    WTAssistantButtonCategoryOA = 0,
    WTAssistantButtonCategoryLibrary = 1,
    WTAssistantButtonCategoryYellowPage = 2,
    WTAssistantButtonCategoryRoute = 3,
    WTAssistantButtonCategoryYiban = 4
} WTAssistantButtonCategory;

@interface WTAssistantViewController : WTRootViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
