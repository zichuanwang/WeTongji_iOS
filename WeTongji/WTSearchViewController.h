//
//  WTSearchViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-11-13.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTRootViewController.h"

@interface WTSearchViewController : WTRootViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, weak) IBOutlet UITextField *districtTextField;
@property (nonatomic, weak) IBOutlet UITextField *buildingTextField;
@property (nonatomic, weak) IBOutlet UITextField *roomTextField;

- (IBAction)didClickRefreshButton:(UIButton *)sender;

@end
