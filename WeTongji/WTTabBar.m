//
//  WTTabBar.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-14.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTTabBar.h"
#import "WTTabBarButton.h"

@interface WTTabBar()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation WTTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bgImage = [UIImage imageNamed:@"WTTabBarBg"];
        self.image = bgImage;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.frame = CGRectMake(0, screenSize.height - bgImage.size.height, screenSize.width, bgImage.size.height);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.userInteractionEnabled = YES;
        //self.multipleTouchEnabled = YES;
        
        [self addTabBarButton];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self.delegate WTTabBar:self didClickTabBarButton:self.buttonArray[0]];
    WTTabBarButton *button = (WTTabBarButton *)self.buttonArray[0];
    button.selected = YES;
    [button showCustomSelectImage];
}

- (void)addTabBarButton {
	const int viewCount = 5;
    
	self.buttonArray = [NSMutableArray arrayWithCapacity:viewCount];
	for (int i = 0; i < viewCount; i++) {
		WTTabBarButton *btn = [[WTTabBarButton alloc] initWithFrame:CGRectMake(64 * i, 0, 64, 50)];
        [btn addTarget:self action:@selector(didClickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
		btn.tag = i;
        
        UIImage *normalStateImage = nil;
        UIImage *selectStateImage = nil;
		switch (i) {
            case 0: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonHome"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonHomeHl"];
                break;
            }
            case 1: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonNow"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonNowHl"];
                break;
            }
            case 2: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearch"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonPowerSearchHl"];
                break;
            }
            case 3: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonBillBoard"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonBillBoardHl"];
                break;
            }
            case 4: {
                normalStateImage = [UIImage imageNamed:@"WTTabBarButtonMe"];
                selectStateImage = [UIImage imageNamed:@"WTTabBarButtonMeHl"];
                break;
            }
        }
        [btn setImage:normalStateImage forState:UIControlStateNormal];
        [btn setImage:selectStateImage forState:UIControlStateSelected];
        [btn setImage:selectStateImage forState:UIControlStateHighlighted];
        
		[self.buttonArray addObject:btn];
		[self addSubview:btn];
	}
}

#pragma mark - Actions

- (void)didClickTabBarButton:(UIButton *)button {
    for(WTTabBarButton *btn in self.buttonArray) {
        btn.selected = NO;
        [btn hideCustomSelectImage];
    }
    button.selected = YES;
    [(WTTabBarButton *)button showCustomSelectImage];
    [self.delegate WTTabBar:self didClickTabBarButton:button];
}

@end
