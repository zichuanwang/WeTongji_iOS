//
//  WTHomeSelectItemView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTHomeSelectItemView : UIView

@property (nonatomic, weak) IBOutlet UILabel *subCategoryLabel;

@end

@interface WTHomeSelectNewsView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UILabel *newsTitleLabel;

+ (WTHomeSelectNewsView *)createHomeSelectNewsView;

@end

@interface WTHomeSelectStarView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIView *avatarContainerView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLbale;

+ (WTHomeSelectStarView *)createHomeSelectStarView;

@end

@interface WTHomeSelectActivityView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;
@property (nonatomic, weak) IBOutlet UIView *posterContainerView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+ (WTHomeSelectActivityView *)createHomeSelectActivityView;

@end
