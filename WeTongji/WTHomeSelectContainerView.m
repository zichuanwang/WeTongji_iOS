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
    if(self) {
        self.itemInfoArray = [[NSMutableArray alloc] initWithArray:@[@"", @"", @""]];
        self.itemViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)didMoveToSuperview {
    self.seeAllLabel.text = NSLocalizedString(@"See All", nil);
    [self configureScrollView];
}

+ (WTHomeSelectContainerView *)createHomeSelectContainerViewWithCategory:(WTHomeSelectContainerViewCategory)category {
    WTHomeSelectContainerView *result = [[[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectContainerView" owner:self options:nil] lastObject];
    switch(category) {
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
    return result;
}

#pragma mark - Logic methods

- (NSUInteger)numberOfItemViewsInScrollView {
    return self.itemInfoArray.count;
}

- (WTHomeSelectItemView *)itemViewAtIndex:(NSUInteger)index {
    if(index >= self.itemViewArray.count) {
        WTHomeSelectItemView *itemView = nil;
        itemView = [[[NSBundle mainBundle] loadNibNamed:@"WTHomeSelectItemView" owner:self options:nil] lastObject];
        [self.itemViewArray addObject:itemView];
        return itemView;
    } else {
        return [self.itemViewArray objectAtIndex:index];
    }
}

#pragma mark - UI methods

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
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

@end
