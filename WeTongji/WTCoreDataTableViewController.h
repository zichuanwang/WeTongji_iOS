//
//  WTCoreDataTableViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTCoreDataViewController.h"

@interface WTCoreDataTableViewController : WTCoreDataViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    BOOL _noAnimationFlag;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// methods to override
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureRequest:(NSFetchRequest *)request;

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)customCellClassName;
- (NSString *)customSectionNameKeyPath;

@end
