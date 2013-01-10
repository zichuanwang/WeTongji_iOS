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


#pragma mark - WTHomeSelectDelegate Protocol

@protocol WTHomeSelectDelegate <NSObject>

- (void)seeAllForCategory:(WTHomeSelectContainerViewCategory)category;

@end

#pragma mark - WTHomeSelectContainerView Interface

@interface WTHomeSelectContainerView : UIView

@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *seeAllLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) id <WTHomeSelectDelegate> selectDelegate;

- (IBAction)didClickSeeAllButton:(UIButton *)sender;

+ (WTHomeSelectContainerView *)createHomeSelectContainerViewWithCategory:(WTHomeSelectContainerViewCategory)category
                                                           itemInfoArray:(NSArray *)array;

@end


