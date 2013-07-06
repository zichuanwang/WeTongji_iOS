//
//  WTLoginIntroItemView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLoginIntroItemView.h"

@implementation WTLoginIntroItemView

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

+ (WTLoginIntroItemView *)createViewWithImage:(UIImage *)image
                                         text:(NSString *)text {
    WTLoginIntroItemView *result = [[NSBundle mainBundle] loadNibNamed:@"WTLoginIntroItemView" owner:nil options:nil].lastObject;
    
    return result;
}

@end
