//
//  WTResourceFactory.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTResourceFactory.h"

#define BUTTON_WIDTH_INCREMENT      30.0f
#define MIN_BACK_BAR_BUTTON_WIDTH   59.0f

@implementation WTResourceFactory

+ (UIBarButtonItem *)createFilterBarButtonWithTarget:(id)target
                                              action:(SEL)action {
    UIButton *button = [WTResourceFactory createNormalButtonWithText:@""];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImage *filterNormalIconImage = [UIImage imageNamed:@"WTFilterSelectIcon"];
    [button setImage:filterNormalIconImage forState:UIControlStateNormal];
    UIImage *filterSelectIconImage = [UIImage imageNamed:@"WTFilterNormalIcon"];
    [button setImage:filterSelectIconImage forState:UIControlStateSelected];
    
    [button resetWidth:filterNormalIconImage.size.width];
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (void)configureFilterBarButton:(UIBarButtonItem *)barButton
                        modified:(BOOL)modified {
    UIButton *filterButton = barButton.customView.subviews.lastObject;
    UIImage *normalBgImage = nil;
    if (modified) {
        normalBgImage = [UIImage imageNamed:@"WTFocusButton"];
    } else {
        normalBgImage = [UIImage imageNamed:@"WTSelectButton"];
    }
    [filterButton setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    [filterButton setBackgroundImage:normalBgImage forState:UIControlStateHighlighted];
}

+ (UIView *)createNavigationBarTitleViewWithText:(NSString *)text {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
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
    UIImage *barBarNormalButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackNormalButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:barBarNormalButtonImage forState:UIControlStateNormal];
    
    UIImage *barBarHighlightButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackHighlightButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:barBarHighlightButtonImage forState:UIControlStateHighlighted];
    
    UIImage *backBarNormalButtonLogoImage = [UIImage imageNamed:@"WTNavigationBarBackNormalButtonIcon"];
    [button setImage:backBarNormalButtonLogoImage forState:UIControlStateNormal];
    
    UIImage *backBarHighlightButtonLogoImage = [UIImage imageNamed:@"WTNavigationBarBackHighlightButtonIcon"];
    [button setImage:backBarHighlightButtonLogoImage forState:UIControlStateHighlighted];
    
    [button resetSize:backBarNormalButtonLogoImage.size];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [WTResourceFactory createBarButtonWithButton:button];
}

+ (UIBarButtonItem *)createBackBarButtonWithText:(NSString *)text
                                   target:(id)target
                                   action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    text = [NSString stringWithFormat:@"  %@", text];
    [button setTitle:text forState:UIControlStateNormal];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 14.0, 0.0, 6.0);
    UIImage *barBarNormalButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackNormalButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:barBarNormalButtonImage forState:UIControlStateNormal];
    
    UIImage *barBarHighlightButtonImage = [[UIImage imageNamed:@"WTNavigationBarBackHighlightButton"] resizableImageWithCapInsets:insets];
    [button setBackgroundImage:barBarHighlightButtonImage forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    CGFloat titleLabelWidth = [text sizeWithFont:button.titleLabel.font].width + BUTTON_WIDTH_INCREMENT;
    titleLabelWidth = titleLabelWidth < MIN_BACK_BAR_BUTTON_WIDTH ? MIN_BACK_BAR_BUTTON_WIDTH : titleLabelWidth;
    [button resetSize:CGSizeMake(titleLabelWidth, barBarNormalButtonImage.size.height)];
    
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

+ (UIButton *)createNormalButtonWithText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    [WTResourceFactory configureNormalButton:button text:text];
    button.selected = YES;
    return button;
}

+ (UIButton *)createFocusButtonWithText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    [WTResourceFactory configureFocusButton:button text:text];
    button.selected = YES;
    return button;
}

+ (void)configureFocusButton:(UIButton *)button
                        text:(NSString *)text {
    [WTResourceFactory configureButton:button
                                  text:text
                            selectText:nil
                           normalImage:[UIImage imageNamed:@"WTSelectButton"]
                        highlightImage:[UIImage imageNamed:@"WTSelectButton"]
                           selectImage:[UIImage imageNamed:@"WTFocusButton"]
                      normalTitleColor:[UIColor whiteColor]
                     normalShadowColor:[UIColor grayColor]
                   highlightTitleColor:[UIColor whiteColor]
                  highlightShadowColor:[UIColor grayColor]
                      selectTitleColor:[UIColor whiteColor]
                     selectShadowColor:[UIColor lightGrayColor]];
}

+ (void)configureNormalButton:(UIButton *)button
                         text:(NSString *)text {
    [WTResourceFactory configureButton:button
                                  text:text
                            selectText:nil
                           normalImage:[UIImage imageNamed:@"WTSelectButton"]
                        highlightImage:[UIImage imageNamed:@"WTSelectButton"]
                           selectImage:[UIImage imageNamed:@"WTNormalButton"]
                      normalTitleColor:[UIColor whiteColor]
                     normalShadowColor:[UIColor grayColor]
                   highlightTitleColor:[UIColor whiteColor]
                  highlightShadowColor:[UIColor grayColor]
                      selectTitleColor:[UIColor darkGrayColor]
                     selectShadowColor:[UIColor whiteColor]];
}

+ (void)configureButton:(UIButton *)button
                         text:(NSString *)text
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
    
    button.adjustsImageWhenHighlighted = NO;
    
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
    
    [button resetSize:CGSizeMake(titleLabelWidth + BUTTON_WIDTH_INCREMENT, normalImage.size.height)];
}

@end
