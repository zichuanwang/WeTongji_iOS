//
//  WTNowActivityCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowActivityCell.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>

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

- (void)configureCellWithTitle:(NSString *)title
                          time:(NSString *)time
                      location:(NSString *)location
                      imageURL:(NSString *)imageURL {
    self.activityNameLabel.text = title;
    [self.activityNameLabel resetWidth:ACTIVITY_NAME_LABEL_WIDTH];
    [self.activityNameLabel sizeToFit];
    
    self.whenLabel.text = time;
    self.whereLabel.text = location;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [self.posterImageView setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             self.posterImageView.image = image;
                                             [self.posterImageView fadeIn];
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

                                         }];
}

@end
