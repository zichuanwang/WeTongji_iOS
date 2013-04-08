//
//  WTHomeSelectContainerView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeSelectContainerView.h"
#import "WTHomeSelectItemView.h"

@interface WTHomeSelectContainerView()

@property (nonatomic, strong) NSMutableArray *itemInfoArray;
@property (nonatomic, strong) NSMutableArray *itemViewArray;

@end

@implementation WTHomeSelectContainerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.itemViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self configureSeeAllButton];
    [self configureScrollView];
}

+ (WTHomeSelectContainerView *)createHomeSelectContainerViewWithCategory:(WTHomeSelectContainerViewCategory)category
                                                           itemInfoArray:(NSArray *)array {
    WTHomeSelectContainerView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectContainerView" owner:self options:nil] lastObject];
    result.category = category;
    switch (category) {
        case WTHomeSelectContainerViewCategoryNews:
        {
            result.categoryLabel.text = NSLocalizedString(@"News", nil);
        }
            break;
        case WTHomeSelectContainerViewCategoryFeatured:
        {
            result.categoryLabel.text = NSLocalizedString(@"Featured", nil);
        }
            break;
        case WTHomeSelectContainerViewCategoryActivity:
        {
            result.categoryLabel.text = NSLocalizedString(@"Activity", nil);
        }
            break;
        default:
            break;
    }
    if (array)
        result.itemInfoArray = [[NSMutableArray alloc] initWithArray:array];
    else
        result.itemInfoArray = [NSMutableArray array];
    
    return result;
}

#pragma mark - Logic methods

- (NSUInteger)numberOfItemViewsInScrollView {
    return self.itemInfoArray.count;
}

- (WTHomeSelectItemView *)itemViewAtIndex:(NSUInteger)index {
    if (index >= self.itemViewArray.count) {
        WTHomeSelectItemView *itemView = nil;
        switch (self.category) {
            case WTHomeSelectContainerViewCategoryNews:
            {
                itemView = [WTHomeSelectNewsView createHomeSelectNewsView];
            }
                break;
            case WTHomeSelectContainerViewCategoryFeatured:
            {
                itemView = [WTHomeSelectStarView createHomeSelectStarView];
            }
                break;
            case WTHomeSelectContainerViewCategoryActivity:
            {
                itemView = [WTHomeSelectActivityView createHomeSelectActivityView];
            }
                break;
            default:
                break;
        }
        [self.itemViewArray addObject:itemView];
        return itemView;
    } else {
        return (self.itemViewArray)[index];
    }
}

#pragma mark - UI methods

- (void)configureSeeAllButton {
    [self.seeAllButton setTitle:NSLocalizedString(@"See All", nil) forState:UIControlStateNormal];
    CGFloat seeAllButtonHeight = self.seeAllButton.frame.size.height;
    CGFloat seeAllButtonCenterY = self.seeAllButton.center.y;
    CGFloat seeAllButtonRightBoundX = self.seeAllButton.frame.origin.x + self.seeAllButton.frame.size
    .width;
    [self.seeAllButton sizeToFit];
    [self.seeAllButton resetHeight:seeAllButtonHeight];
    [self.seeAllButton resetCenterY:seeAllButtonCenterY];
    [self.seeAllButton resetOriginX:seeAllButtonRightBoundX - self.seeAllButton.frame.size.width];
}

- (void)configureScrollView {
    for(NSUInteger i = 0; i < [self numberOfItemViewsInScrollView]; i++) {
        WTHomeSelectItemView *itemView = [self itemViewAtIndex:i];
        [self.scrollView addSubview:itemView];
    }
    [self layoutScrollView];
}

- (void)layoutScrollView {
    CGFloat scrollViewContentWidth = [self numberOfItemViewsInScrollView] > 1 ? self.scrollView.frame.size.width * [self numberOfItemViewsInScrollView] : self.scrollView.frame.size.width + 1;
    self.scrollView.contentSize = CGSizeMake(scrollViewContentWidth, self.scrollView.frame.size.height);
    
    for(NSUInteger i = 0; i < [self numberOfItemViewsInScrollView]; i++) {
        WTHomeSelectItemView *itemView = [self itemViewAtIndex:i];
        
        itemView.center = CGPointMake(self.scrollView.frame.size.width * (i + 0.5f), self.scrollView.frame.size.height / 2);
    }
    
    self.scrollView.contentOffset = CGPointMake(-self.scrollView.contentInset.left, 0);
}

#pragma mark - Actions

- (void)didClickSeeAllButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeSelectContainerViewDidClickSeeAllButton:)]) {
        [self.delegate homeSelectContainerViewDidClickSeeAllButton:self];
    }
}

@end
