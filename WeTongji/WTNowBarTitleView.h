//
//  WTNowBarTitleView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-15.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTNowBarTitleView : UIView

@property (nonatomic, weak) IBOutlet UIView *titleBgView;
@property (nonatomic, weak) IBOutlet UILabel *weekDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *weekLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *weekContainerView;

@end
