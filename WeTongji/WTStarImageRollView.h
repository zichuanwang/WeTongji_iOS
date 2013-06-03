//
//  WTStarImageRollView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTStarImageRollItemView;

@interface WTStarImageRollView : UIView

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIImageView *rightShadowImageView;

+ (WTStarImageRollView *)createImageRollViewWithImageURLStringArray:(NSArray *)imageURLArray;

- (WTStarImageRollItemView *)currentItemView;

- (WTStarImageRollItemView *)itemViewAtIndex:(NSUInteger)index;

- (void)reloadItemImages;

@end

@interface WTStarImageRollItemView : UIView

@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

+ (WTStarImageRollItemView *)createItemViewWithImageURLString:(NSString *)imageURLString;

@end
