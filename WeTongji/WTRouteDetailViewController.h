//
//  WTRouteDetailViewController.h
//  WeTongji
//
//  Created by Tom Hu on 13-10-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRootViewController.h"

@interface WTRouteDetailViewController : WTRootViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

+ (WTRouteDetailViewController *)createDetailViewControllerWithRouteInfo:(NSDictionary *)routeInfo;

@end
