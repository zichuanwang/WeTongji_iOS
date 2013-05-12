//
//  WTSelfProfileView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface WTSelfProfileView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *secondSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *firstSectionBgImageView;

+ (WTSelfProfileView *)createSelfProfileViewWithUser:(User *)user;

@end
