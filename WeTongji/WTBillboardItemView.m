//
//  WTDetailDescriptionView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-10.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "BillboardPost.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>

@implementation WTBillboardItemView

enum {
    BillboardLargeItemViewTag = 1000,
    BillboardSmallItemViewTag = 2000,
};

+ (WTBillboardItemView *)createItemView:(BOOL)large {
    int tag = large ? BillboardLargeItemViewTag : BillboardSmallItemViewTag;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTBillboardItemView" owner:self options:nil];
    for (UIView *view in views) {
        if (view.tag == tag)
            return (WTBillboardItemView *)view;
    }
    return nil;
}

+ (WTBillboardItemView *)createLargeItemView {
    return [WTBillboardItemView createItemView:YES];
}

+ (WTBillboardItemView *)createSmallItemView {
    return [WTBillboardItemView createItemView:NO];
}

- (void)didMoveToSuperview {
    self.imageContainerView.layer.masksToBounds = YES;
    self.imageContainerView.layer.cornerRadius = 6.0f;
}

- (void)configureViewWithBillboardPost:(BillboardPost *)post {
    if (post.image) {
        self.imageTextContainerView.hidden = NO;
        self.plainTextContainerView.hidden = YES;
        
        self.imageTitleLabel.text = post.title;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:post.image]];
        [self.imageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           self.imageView.image = image;
                                           [self.imageView fadeIn];
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           
                                       }];
        
    } else {
        self.imageTextContainerView.hidden = YES;
        self.plainTextContainerView.hidden = NO;
        
        self.plainTitleLabel.text = post.title;
        self.plainContentLabel.text = post.content;
        
        [self.plainTitleLabel resetWidth:self.plainContentLabel.frame.size.width];
        [self.plainTitleLabel sizeToFit];
        [self.plainContentLabel resetHeight:self.plainTextContainerView.frame.size.height - self.plainTitleLabel.frame.size.height - self.plainTitleLabel.frame.origin.y - 18.0f];
        [self.plainContentLabel resetOriginY:self.plainTitleLabel.frame.origin.y + self.plainTitleLabel.frame.size.height + 6.0f];
    }
}

@end
