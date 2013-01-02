//
//  WTHomeSelectItemView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHomeSelectItemView.h"
#import "WTResourceFactory.h"

@interface WTHomeSelectItemView()

@property (nonatomic, strong) UIButton *showAllButton;

@end

@implementation WTHomeSelectItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didMoveToSuperview {
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 12, 0, 12);
    UIImage *bgImage = [[UIImage imageNamed:@"WTHomeSelectItemViewBg"] resizableImageWithCapInsets:insets];
    self.bgImageView.image = bgImage;
    
    [self addSubview:self.showAllButton];
}

#pragma mark - Properties

- (UIButton *)showAllButton {
    if(_showAllButton == nil) {
        _showAllButton = [WTResourceFactory createNormalButtonWithText:NSLocalizedString(@"Show All", nil)];
        [_showAllButton resetOrigin:CGPointMake(self.frame.size.width - _showAllButton.frame.size.width - 8, -3)];
    }
    return _showAllButton;
}

@end
