//
//  WTOtherUserProfileView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class OHAttributedLabel;

@interface WTOtherUserProfileView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *firstSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIView *firstSectionContianerView;
@property (nonatomic, weak) IBOutlet UIView *secondSectionContianerView;
@property (nonatomic, weak) IBOutlet UILabel *detailInformationDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *activityLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *friendLabel;

+ (WTOtherUserProfileView *)createProfileViewWithUser:(User *)user;

@end
