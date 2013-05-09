//
//  WTCourseDetialViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseDetialViewController.h"
#import "Course+Addition.h"

@interface WTCourseDetialViewController ()

@property (nonatomic, strong) Course *course;

@end

@implementation WTCourseDetialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTCourseDetialViewController *)createCourseDetailViewControllerWithCourse:(Course *)course
                                                           backBarButtonText:(NSString *)backBarButtonText {
    WTCourseDetialViewController *result = [[WTCourseDetialViewController alloc] init];
    result.course = course;
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

@end
