//
//  WTCommentCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCommentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "Comment+Addition.h"
#import "User+Addition.h"
#import "NSString+WTAddition.h"

@implementation WTCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [self configureAvatarView];
}

- (void)configureAvatarView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 3.0f;
}

- (void)configureViewWithComment:(Comment *)comment {
    self.authorLabel.text = comment.author.name;
    self.timeLabel.text = [comment.createdAt convertToYearMonthDayWeekString];
    [self.avatarImageView loadImageWithImageURLString:comment.author.avatar];
}

@end
