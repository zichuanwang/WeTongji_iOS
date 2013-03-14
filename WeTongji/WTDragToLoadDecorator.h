//
//  WTDragToLoadDecorator.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WTDragToLoadDecoratorDataSource <NSObject>

- (UIScrollView *)dragToLoadScrollView;

@end

@protocol WTDragToLoadDecoratorDelegate <NSObject>

- (void)dragToLoadDecoratorDidDragUp;

- (void)dragToLoadDecoratorDidDragDown;

@end

@interface WTDragToLoadDecorator : NSObject

@property (nonatomic, weak) id<WTDragToLoadDecoratorDataSource> dataSource;
@property (nonatomic, weak) id<WTDragToLoadDecoratorDelegate> delegate;

+ (WTDragToLoadDecorator *)createDecoratorWithDataSource:(id<WTDragToLoadDecoratorDataSource>)dataSource
                                                delegate:(id<WTDragToLoadDecoratorDelegate>)delegate;

- (void)hideTopView:(BOOL)loadSucceeded;

- (void)hideBottomView:(BOOL)loadSucceeded;

- (void)scrollViewDidScroll;

@end

@interface WTDragToLoadDecoratorTopView : UIView

@property (nonatomic, weak) IBOutlet UILabel *dragStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *updateTimeLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (WTDragToLoadDecoratorTopView *)createTopView;

@end

@interface WTDragToLoadDecoratorBottomView : UIView

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (WTDragToLoadDecoratorBottomView *)createBottomView;

@end
