//
//  WTBillboardTableViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardTableViewController.h"
#import "WTBillboardCell.h"
#import "BillboardPost.h"

@interface WTBillboardTableViewController ()

@end

@implementation WTBillboardTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfItems = [self.fetchedResultsController.sections[0] numberOfObjects];
    NSInteger result = numberOfItems / 3 + ((numberOfItems % 3 == 0) ? 0 : 1);
    return result;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTBillboardCell *billboardCell = (WTBillboardCell *)cell;
    NSMutableArray *postArray = [NSMutableArray arrayWithCapacity:3];
    NSInteger numberOfItems = [self.fetchedResultsController.sections[0] numberOfObjects];
    
    for (int i = indexPath.row * 3; i < (indexPath.row + 1) * 3; i++) {
        if (i >= numberOfItems)
            break;
        BillboardPost *post = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [postArray addObject:post];
    }
    [billboardCell configureCellWithBillboardPosts:postArray indexPath:indexPath];
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"BillboardPost" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    NSSortDescriptor *createTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:createTimeDescriptor]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTBillboardCell";
}

//- (void)fetchedResultsControllerDidPerformFetch:(NSFetchedResultsController *)aFetchedResultsController {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
//        if ([aFetchedResultsController.sections.lastObject numberOfObjects] == 0) {
//            [self.dragToLoadDecorator setTopViewLoading:YES];
//        }
//    });
//}

@end
