//
//  WTNowBaseCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowCourseCell.h"

@implementation WTNowCourseCell

#define COURSE_NAME_LABEL_WIDTH 260.0f

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configureCellWithTitle:(NSString *)title
                          time:(NSString *)time
                      location:(NSString *)location {
    self.courseNameLabel.text = title;
    [self.courseNameLabel resetWidth:COURSE_NAME_LABEL_WIDTH];
    [self.courseNameLabel sizeToFit];
    
    self.whenLabel.text = time;
    self.whereLabel.text = location;
}

@end
