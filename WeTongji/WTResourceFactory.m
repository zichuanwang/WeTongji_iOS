//
//  WTResourceFactory.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTResourceFactory.h"

@implementation WTResourceFactory

+ (UIButton *)createNormalButtonWithText:(NSString *)text {
    return [WTResourceFactory createButtonWithText:text
                                        normalImage:[UIImage imageNamed:@"WTNormalButton"]
                                        selectImage:nil
                                   normalTitleColor:[UIColor darkGrayColor]
                                 normalShadowColor:[UIColor whiteColor]
                                   selectTitleColor:nil
                                  selectShadowColor:nil];
}

+ (UIButton *)createFocusButtonWithText:(NSString *)text {
    return [WTResourceFactory createButtonWithText:text
                                       normalImage:[UIImage imageNamed:@"WTFocusButton"]
                                       selectImage:[UIImage imageNamed:@"WTSelectButton"]
                                  normalTitleColor:[UIColor whiteColor]
                                 normalShadowColor:[UIColor lightGrayColor]
                                  selectTitleColor:[UIColor whiteColor]
                                 selectShadowColor:[UIColor grayColor]];
}


+ (UIButton *)createButtonWithText:(NSString *)text
                       normalImage:(UIImage *)normalImage
                       selectImage:(UIImage *)selectImage
                  normalTitleColor:(UIColor *)normalTitleColor
                  normalShadowColor:(UIColor *)normalShadowColor
                  selectTitleColor:(UIColor *)selectTitleColor
                 selectShadowColor:(UIColor *)selectShadowColor{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:text forState:UIControlStateNormal];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    if(normalImage) {
        UIImage *resizableNormalImage = [normalImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableNormalImage forState:UIControlStateNormal];
    }
    
    if(selectImage) {
        UIImage *resizableSelectImage = [selectImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableSelectImage forState:UIControlStateSelected];
    }
        
    if(normalTitleColor)
        [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    
    if(normalShadowColor)
        [button setTitleShadowColor:normalShadowColor forState:UIControlStateNormal];

    if(selectTitleColor)
        [button setTitleColor:selectTitleColor forState:UIControlStateSelected];
    
    if(selectShadowColor)
        [button setTitleShadowColor:selectShadowColor forState:UIControlStateSelected];

    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    CGFloat titleLabelWidth = [text sizeWithFont:button.titleLabel.font].width;
    
    [button resetSize:CGSizeMake(titleLabelWidth + 30, normalImage.size.height)];
    
    return button;
}

@end
