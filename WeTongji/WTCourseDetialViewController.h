//
//  WTCourseDetialViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTDetailViewController.h"

@class Course;

@interface WTCourseDetialViewController : WTDetailViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

+ (WTCourseDetialViewController *)createCourseDetailViewControllerWithCourse:(Course *)course
                                                                 backBarButtonText:(NSString *)backBarButtonText;

@end
