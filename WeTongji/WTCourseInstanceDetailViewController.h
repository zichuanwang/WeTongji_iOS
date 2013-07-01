//
//  WTCourseInstanceDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDetailViewController.h"

@class CourseInstance;

@interface WTCourseInstanceDetailViewController : WTDetailViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

+ (WTCourseInstanceDetailViewController *)createDetailViewControllerWithCourseInstance:(CourseInstance *)courseInstance
                                                                     backBarButtonText:(NSString *)backBarButtonText;

@end
