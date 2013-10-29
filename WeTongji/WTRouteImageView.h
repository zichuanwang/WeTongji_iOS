//
//  WTRouteImageView.h
//  WeTongji
//
//  Created by Tom Hu on 13-10-29.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTRouteImageView : UIView

@property (nonatomic, weak) IBOutlet UIScrollView *firstRouteScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *secondRouteScrollView;

+ (WTRouteImageView *)createRouteImageViewWithImageNamge:(NSDictionary *)routeInfo;

@end
