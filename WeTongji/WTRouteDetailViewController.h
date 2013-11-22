//
//  WTRouteDetailViewController.h
//  WeTongji
//
//  Created by Tom Hu on 13-10-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailViewController.h"

@interface WTRouteDetailViewController : WTDetailViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

+ (WTRouteDetailViewController *)createDetailViewControllerWithRouteInfo:(NSDictionary *)routeInfo;

@end
