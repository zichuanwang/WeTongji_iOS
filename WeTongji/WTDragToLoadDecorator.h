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

@optional
- (NSString *)userDefaultKey;

@end

@protocol WTDragToLoadDecoratorDelegate <NSObject>

- (void)dragToLoadDecoratorDidDragDown;

@optional
- (void)dragToLoadDecoratorDidDragUp;

@end

@interface WTDragToLoadDecorator : NSObject

@property (nonatomic, weak) id<WTDragToLoadDecoratorDataSource> dataSource;
@property (nonatomic, weak) id<WTDragToLoadDecoratorDelegate> delegate;

+ (WTDragToLoadDecorator *)createDecoratorWithDataSource:(id<WTDragToLoadDecoratorDataSource>)dataSource
                                                delegate:(id<WTDragToLoadDecoratorDelegate>)delegate;

- (void)topViewLoadFinished:(BOOL)loadSucceeded;

- (void)bottomViewLoadFinished:(BOOL)loadSucceeded;

- (void)setTopViewDisabled:(BOOL)disabled;

// Call this method before |bottomViewLoadFinished:|.
- (void)setBottomViewDisabled:(BOOL)disabled;

- (void)setTopViewLoading:(BOOL)animated;

// Call this method in your UIViewController's |viewDidLoad| and
// |viewDidAppear:animated:|.
- (void)startObservingChangesInDragToLoadScrollView;

// Call this method in your UIViewController's |viewDidDisappear:animated:|.
- (void)stopObservingChangesInDragToLoadScrollView;

- (void)scrollViewDidLoadNewCell;

@end

@interface WTDragToLoadDecoratorTopView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *cloudImageView;
@property (nonatomic, weak) IBOutlet UIImageView *dropletImageView;

+ (WTDragToLoadDecoratorTopView *)createTopView;

- (void)startLoadingAnimation;

- (void)stopLoadingAnimation;

- (void)configureCloudAndDropletHeightWithRatio:(float)ratio;

@end

@interface WTDragToLoadDecoratorBottomView : UIView

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (WTDragToLoadDecoratorBottomView *)createBottomView;

@end
