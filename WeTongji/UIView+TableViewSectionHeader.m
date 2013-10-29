//
//  UIView+TableViewSectionHeader.m
//  WeTongji
//
//  Created by 王 紫川 on 13-8-27.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "UIView+TableViewSectionHeader.h"

@implementation UIView (TableViewSectionHeader)

+ (UIView *)sectionHeaderViewWithSectionName:(NSString *)sectionName {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    CGFloat sectionHeaderHeight = bgImageView.frame.size.height;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, 320.0f - 20.0f, sectionHeaderHeight)];
    label.text = sectionName;
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = WTSectionHeaderViewGrayColor;
    label.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 24.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:bgImageView];
    [headerView addSubview:label];
    
    return headerView;
}

@end
