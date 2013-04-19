//
//  WTNowActivityCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowActivityCell.h"
#import "UIImageView+AsyncLoading.h"
#import "Activity.h"
#import "Event+Addition.h"

@implementation WTNowActivityCell

#define ACTIVITY_NAME_LABEL_WIDTH   210.0f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - UI methods

- (void)setCellPast:(BOOL)past {
    [super setCellPast:past];
    
    if (past) {
        self.posterContainerView.alpha = 0.5f;
        self.activityNameLabel.highlighted = YES;
        self.activityNameLabel.shadowOffset = CGSizeZero;
    } else {
        self.posterContainerView.alpha = 1.0f;
        self.activityNameLabel.highlighted = NO;
        self.activityNameLabel.shadowOffset = CGSizeMake(0, 1);
    }
}

#define NOW_ACTIVITY_LABEL_WHERE_LABEL_MIN_ORIGIN_Y 76.0f

- (void)configureCellWithEvent:(Event *)event {
    [super configureCellWithEvent:event];
    
    Activity *activity = (Activity *)event;
    self.whenLabel.text = activity.beginToEndTimeString;
    
    self.activityNameLabel.text = activity.what;
    [self.activityNameLabel resetWidth:ACTIVITY_NAME_LABEL_WIDTH];
    [self.activityNameLabel sizeToFit];
    
    self.whereLabel.text = activity.where;
    [self.whereLabel resetOriginY:self.activityNameLabel.frame.origin.y + self.activityNameLabel.frame.size.height + 6.0f];
    if (self.whereLabel.frame.origin.y < NOW_ACTIVITY_LABEL_WHERE_LABEL_MIN_ORIGIN_Y)
        [self.whereLabel resetOriginY:NOW_ACTIVITY_LABEL_WHERE_LABEL_MIN_ORIGIN_Y];
    
    self.posterPlaceholderImageView.alpha = 1.0f;
    
    [self.posterImageView loadImageWithImageURLString:activity.image];
}

@end
