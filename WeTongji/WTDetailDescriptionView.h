//
//  WTDetailDescriptionView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHAttributedLabel;

@interface WTDetailDescriptionView : UIView

@property (nonatomic, weak) IBOutlet UILabel *organizerDisplayLabel;
@property (nonatomic, weak) IBOutlet UIButton *organizerButton;
@property (nonatomic, weak) IBOutlet UIView *contentContainerView;
@property (nonatomic, weak) IBOutlet UILabel *aboutDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIView *organizerAvatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *organizerAvatarImageView;

+ (WTDetailDescriptionView *)createDetailDescriptionView;

- (void)configureViewWithManagedObject:(id)object;

@end