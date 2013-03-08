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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.activityNameLabel sizeToFit];
}

- (void)configureCellWithtitle:(NSString *)title
                          time:(NSString *)time
                      location:(NSString *)location
                      imageURL:(NSString *)imageURL;
{
    self.activityNameLabel.text = title;
    self.whenLabel.text = time;
    self.whereLabel.text = location;
    self.friendsCountLabel.text = count;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [self.posterImageView setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             self.posterImageView.image = image;
                                             [self.posterImageView fadeIn];
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             WTLOGERROR(@"The specified image: \"%@\" cannot be found on server", [[NSURL URLWithString:imageURL] lastPathComponent]);
                                         }];
}

@end
