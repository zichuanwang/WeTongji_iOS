//
//  WTWaterflowDecorator.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTWaterflowDecorator.h"

@interface WTWaterflowDecorator ()

@property (nonatomic, strong) UIImageView *waterflowImageViewA;
@property (nonatomic, strong) UIImageView *waterflowImageViewB;

@end

@implementation WTWaterflowDecorator

+ (WTWaterflowDecorator *)createDecoratorWithDataSource:(id<WTWaterflowDecoratorDataSource>) dataSource {
    WTWaterflowDecorator *result = [[WTWaterflowDecorator alloc] init];
    result.dataSource = dataSource;
    return result;
}

#pragma mark - Adjust waterflow view method

- (void)adjustWaterflowView {
    UIImageView *scrollBackgroundViewA = self.waterflowImageViewA;
    UIImageView *scrollBackgroundViewB = self.waterflowImageViewB;
    UIScrollView *scrollView = [self.dataSource waterflowScrollView];
    
    if (!(scrollBackgroundViewA && scrollBackgroundViewB && scrollView))
        return;
    
    CGFloat top = scrollView.contentOffset.y;
    CGFloat bottom = top + scrollView.frame.size.height;
    
    UIView *upperView = nil;
    UIView *lowerView = nil;
    BOOL alignToTop = NO;
    
    if ((alignToTop = [WTWaterflowDecorator view:scrollBackgroundViewA containsPoint:top]) || [WTWaterflowDecorator view:scrollBackgroundViewB containsPoint:bottom]) {
        upperView = scrollBackgroundViewA;
        lowerView = scrollBackgroundViewB;
    } else if((alignToTop = [WTWaterflowDecorator view:scrollBackgroundViewB containsPoint:top]) || [WTWaterflowDecorator view:scrollBackgroundViewA containsPoint:bottom]) {
        upperView = scrollBackgroundViewB;
        lowerView = scrollBackgroundViewA;
    }
    
    if (upperView && lowerView) {
        if (alignToTop) {
            [lowerView resetOriginY:upperView.frame.origin.y + upperView.frame.size.height];
        } else {
            [upperView resetOriginY:lowerView.frame.origin.y - lowerView.frame.size.height];
        }
    } else {
        [scrollBackgroundViewA resetOriginY:top];
        [scrollBackgroundViewB resetOriginY:scrollBackgroundViewA.frame.origin.y + scrollBackgroundViewA.frame.size.height];
    }
}

#pragma mark - Help methods

+ (BOOL)view:(UIView *)view containsPoint:(CGFloat)originY {
    return view.frame.origin.y <= originY && view.frame.origin.y + view.frame.size.height > originY;
}

+ (UIImageView *)createWaterflowImageViewWithImageName:(NSString *)imageName frame:(CGRect)frame {
    UIImageView *result = nil;
    result = [[UIImageView alloc] initWithFrame:frame];
    result.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    result.image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsZero];
    return result;
}

#pragma mark - Properties

- (UIImageView *)waterflowImageViewA {
    if (!_waterflowImageViewA) {
        UIScrollView *scrollView = [self.dataSource waterflowScrollView];
        if (scrollView) {
            _waterflowImageViewA = [WTWaterflowDecorator createWaterflowImageViewWithImageName:[self.dataSource waterflowUnitImageName] frame:scrollView.frame];
            [scrollView insertSubview:_waterflowImageViewA atIndex:0];
        }
    }
    return _waterflowImageViewA;
}

- (UIImageView *)waterflowImageViewB {
    if (!_waterflowImageViewB) {
        UIScrollView *scrollView = [self.dataSource waterflowScrollView];
        if (scrollView) {
            _waterflowImageViewB = [WTWaterflowDecorator createWaterflowImageViewWithImageName:[self.dataSource waterflowUnitImageName] frame:scrollView.frame];
            [scrollView insertSubview:_waterflowImageViewB atIndex:0];
        }
    }
    return _waterflowImageViewB;
}

@end
