//
//  WTCurrentUserProfileView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class OHAttributedLabel;

@interface WTCurrentUserProfileView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *firstSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIView *firstSectionContianerView;
@property (nonatomic, weak) IBOutlet UIView *secondSectionContianerView;
@property (nonatomic, weak) IBOutlet UILabel *myFavoriteDisplayLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *myFriendLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *myBillboardPostLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *myQuestionsLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedActivityLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedNewsLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedBillboardPostLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedOrganizationLabel;
@property (nonatomic, weak) IBOutlet OHAttributedLabel *likedPersonLabel;
@property (nonatomic, weak) IBOutlet UIButton *likedActiviyButton;
@property (nonatomic, weak) IBOutlet UIButton *likedNewsButton;
@property (nonatomic, weak) IBOutlet UIButton *likedOrganizationButton;
@property (nonatomic, weak) IBOutlet UIButton *likedBillboardPostButton;
@property (nonatomic, weak) IBOutlet UIButton *likedUserButton;
@property (nonatomic, weak) IBOutlet UIButton *friendButton;

+ (WTCurrentUserProfileView *)createProfileViewWithUser:(User *)user;

@end
