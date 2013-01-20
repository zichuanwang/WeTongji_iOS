//
//  WTSwitch.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-20.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTSwitchDelegate;

@interface WTSwitch : UIView <UIScrollViewDelegate> {
    BOOL _switchState;
}

@property (nonatomic, strong) IBOutlet UILabel *onLabel;
@property (nonatomic, strong) IBOutlet UILabel *offLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *handlerButton;

@property (nonatomic, weak) id<WTSwitchDelegate> delegate;

+ (WTSwitch *)createSwitchWithDelegate:(id<WTSwitchDelegate>)delegate;

@end

@protocol WTSwitchDelegate <NSObject>

@optional
- (void)switchDidChange:(WTSwitch *)sender;

@end
