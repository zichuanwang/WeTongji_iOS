//
//  WTHomeSelectContainerView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WTHomeSelectContainerViewCategoryNews,
    WTHomeSelectContainerViewCategoryFeatured,
    WTHomeSelectContainerViewCategoryActivity,
} WTHomeSelectContainerViewCategory;

@protocol WTHomeSelectContainerViewDelegate;

#pragma mark - WTHomeSelectContainerView Interface

@interface WTHomeSelectContainerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *seeAllLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) id <WTHomeSelectContainerViewDelegate> delegate;
@property (nonatomic, assign) WTHomeSelectContainerViewCategory category;

- (IBAction)didClickSeeAllButton:(UIButton *)sender;

+ (WTHomeSelectContainerView *)createHomeSelectContainerViewWithCategory:(WTHomeSelectContainerViewCategory)category
                                                           itemInfoArray:(NSArray *)array;

@end

#pragma mark - WTHomeSelectContainerViewDelegate Protocol

@protocol WTHomeSelectContainerViewDelegate <NSObject>

- (void)homeSelectContainerViewDidClickSeeAllButton:(WTHomeSelectContainerView *)containerView;

@end

