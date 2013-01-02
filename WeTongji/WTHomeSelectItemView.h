//
//  WTHomeSelectItemView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTHomeSelectItemView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UILabel *subCategoryLabel;

@end

@interface WTHomeSelectNewsView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UILabel *newsTitleLabel;

+ (WTHomeSelectNewsView *)createHomeSelectNewsView;

@end

@interface WTHomeSelectStarView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

+ (WTHomeSelectStarView *)createHomeSelectStarView;

@end

@interface WTHomeSelectActivityView : WTHomeSelectItemView

@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;

+ (WTHomeSelectActivityView *)createHomeSelectActivityView;

@end
