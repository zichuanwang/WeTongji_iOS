//
//  WTTabBarButton.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-14.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTTabBarButton.h"
#import "WTSoundManager.h"

@interface WTTabBarButton() {
    BOOL _playPianoToneLock;
}

@end

@implementation WTTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.customSelectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.customSelectImageView];
        self.customSelectImageView.hidden = YES;
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

- (void)setHighlighted:(BOOL)highlighted {
    if(self.highlighted == NO && highlighted == YES && _playPianoToneLock == NO) {
        [[WTSoundManager sharedManager] playPianoTone:self.tag + 1];
    }
    [super setHighlighted:highlighted];
}

- (void)showCustomSelectImage {
    self.customSelectImageView.hidden = NO;
}

- (void)hideCustomSelectImage {
    self.customSelectImageView.hidden = YES;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    if(state == UIControlStateSelected) {
        self.customSelectImageView.image = image;
    }
}

@end
