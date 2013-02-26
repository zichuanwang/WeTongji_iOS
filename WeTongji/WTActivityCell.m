//
//  WTActivityCell.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTActivityCell.h"
#import "WTCommonConstant.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>

@interface WTActivityCell ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation WTActivityCell

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title time:(NSString *)time location:(NSString *)location imageURL:(NSString *)imageURL {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    self.titleLabel.text = title;
    self.timeLabel.text = time;
    self.locationLabel.text = location;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [self.posterImageView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        self.posterImageView.image = image;
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"The specified image: \"%@\" cannot be found on server", [[NSURL URLWithString:imageURL] lastPathComponent]);
                                   }];
}

@end
