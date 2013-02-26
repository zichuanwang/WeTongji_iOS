//
//  WTResourceFactory.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTResourceFactory.h"

@implementation WTResourceFactory

+ (UIBarButtonItem *)createFilterBarButtonWithTarget:(id)target
                                              action:(SEL)action {
    UIButton *button = [WTResourceFactory createFocusButtonWithText:@""];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *filterLogoImage = [UIImage imageNamed:@"WTFilterLogo"];
    [button setImage:filterLogoImage forState:UIControlStateNormal];
    [button resetWidth:filterLogoImage.size.width];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIView *)createNavigationBarTitleViewWithText:(NSString *)text {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.text = text;
    [titleLabel sizeToFit];
    
    UIView *titleContainerView = [[UIView alloc] initWithFrame:titleLabel.frame];
    [titleLabel resetOriginY:0];
    [titleContainerView addSubview:titleLabel];
    
    return titleContainerView;
}

+ (UIBarButtonItem *)createNormalBarButtonWithText:(NSString *)text
                                            target:(id)target
                                            action:(SEL)action {
    UIButton *button = [WTResourceFactory createNormalButtonWithText:text];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createFocusBarButtonWithText:(NSString *)text
                                            target:(id)target
                                            action:(SEL)selector {
    UIButton *button = [WTResourceFactory createFocusButtonWithText:text];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createLogoBackBarButtonWithTarget:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 8.0, 0.0, 6.0);
    UIImage *image = [[UIImage imageNamed:@"WTNavigationBarBackButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage *backBarButtonLogoImage = [UIImage imageNamed:@"WTNavigationBarBackButtonLogo"];
    [button setImage:backBarButtonLogoImage forState:UIControlStateNormal];
    
    [button resetSize:backBarButtonLogoImage.size];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createBackBarButtonWithText:(NSString *)text
                                   target:(id)target
                                   action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    text = [NSString stringWithFormat:@"  %@", text];
    [button setTitle:text forState:UIControlStateNormal];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 8.0, 0.0, 6.0);
    UIImage *image = [[UIImage imageNamed:@"WTNavigationBarBackButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    CGFloat titleLabelWidth = [text sizeWithFont:button.titleLabel.font].width;
    CGFloat minTitleLabelWidth = 59;
    titleLabelWidth = titleLabelWidth < minTitleLabelWidth ? minTitleLabelWidth : titleLabelWidth;
    [button resetSize:CGSizeMake(titleLabelWidth, image.size.height)];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createBarButtonWithButton:(UIButton *)button {
    UIView *containerView = [[UIView alloc] initWithFrame:button.frame];
    [button resetOrigin:CGPointMake(0, 1)];
    [containerView addSubview:button];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    return barBtnItem;
}

+ (UIButton *)createNormalButtonWithText:(NSString *)text
                              selectText:(NSString *)selectText {
    return [WTResourceFactory createButtonWithText:text
                                        selectText:selectText
                                       normalImage:[UIImage imageNamed:@"WTNormalButton"]
                                    highlightImage:nil
                                       selectImage:[UIImage imageNamed:@"WTSelectButton"]
                                  normalTitleColor:[UIColor darkGrayColor]
                                 normalShadowColor:[UIColor whiteColor]
                               highlightTitleColor:[UIColor darkGrayColor]
                              highlightShadowColor:[UIColor grayColor]
                                  selectTitleColor:[UIColor whiteColor]
                                 selectShadowColor:[UIColor grayColor]];
}

+ (UIButton *)createNormalButtonWithText:(NSString *)text {
    return [WTResourceFactory createNormalButtonWithText:text selectText:nil];
}

+ (UIButton *)createFocusButtonWithText:(NSString *)text {
    UIButton *result = [WTResourceFactory createButtonWithText:text
                                                    selectText:nil
                                                   normalImage:[UIImage imageNamed:@"WTSelectButton"]
                                                highlightImage:nil
                                                   selectImage:[UIImage imageNamed:@"WTFocusButton"]
                                              normalTitleColor:[UIColor whiteColor]
                                             normalShadowColor:[UIColor lightGrayColor]
                                           highlightTitleColor:[UIColor grayColor]
                                          highlightShadowColor:[UIColor darkGrayColor]
                                              selectTitleColor:nil
                                             selectShadowColor:nil];
    result.selected = YES;
    return result;
}

+ (UIButton *)createButtonWithText:(NSString *)text
                        selectText:(NSString *)selectText
                       normalImage:(UIImage *)normalImage
                    highlightImage:(UIImage *)highlightImage
                       selectImage:(UIImage *)selectImage
                  normalTitleColor:(UIColor *)normalTitleColor
                 normalShadowColor:(UIColor *)normalShadowColor
               highlightTitleColor:(UIColor *)highlightTitleColor
              highlightShadowColor:(UIColor *)highlightShadowColor
                  selectTitleColor:(UIColor *)selectTitleColor
                 selectShadowColor:(UIColor *)selectShadowColor {
    UIButton *button = [[UIButton alloc] init];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    if (normalImage) {
        UIImage *resizableNormalImage = [normalImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableNormalImage forState:UIControlStateNormal];
    }
    
    if (highlightImage) {
        UIImage *resizableHighlightImage = [highlightImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableHighlightImage forState:UIControlStateHighlighted];
    }
    
    if (selectImage) {
        UIImage *resizableSelectImage = [selectImage resizableImageWithCapInsets:insets];
        [button setBackgroundImage:resizableSelectImage forState:UIControlStateSelected];
    }
        
    if (normalTitleColor)
        [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    
    if (normalShadowColor)
        [button setTitleShadowColor:normalShadowColor forState:UIControlStateNormal];

    if (highlightTitleColor)
        [button setTitleColor:highlightTitleColor forState:UIControlStateHighlighted];
    
    if (highlightShadowColor)
        [button setTitleShadowColor:highlightShadowColor forState:UIControlStateHighlighted];
    
    if (selectTitleColor)
        [button setTitleColor:selectTitleColor forState:UIControlStateSelected];
    
    if (selectShadowColor)
        [button setTitleShadowColor:selectShadowColor forState:UIControlStateSelected];

    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    CGFloat titleLabelWidth = [text sizeWithFont:button.titleLabel.font].width;
    
    if (selectText) {
        [button setTitle:selectText forState:UIControlStateSelected];
        CGFloat selectTextWidth = [selectText sizeWithFont:button.titleLabel.font].width;
        titleLabelWidth = titleLabelWidth < selectTextWidth ? selectTextWidth : titleLabelWidth;
    }
    
    [button resetSize:CGSizeMake(titleLabelWidth + 30, normalImage.size.height)];
    
    return button;
}

@end
