//
//  WTBillboardTableViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardTableViewController.h"
#import "WTBillboardCell.h"
#import "BillboardPost+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTDragToLoadDecorator.h"

@interface WTBillboardTableViewController () <WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation WTBillboardTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.nextPage = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureDragToLoadDecorator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

#pragma mark - Logic methods

- (void)reloadDataWithSuccessBlock:(void (^)(void))success
                      failureBlock:(void (^)(void))failure {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Billboard:%@", responseObject);
        
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        NSString *nextPage = resultDict[@"NextPager"];
        self.nextPage = nextPage.integerValue;
        
        if (self.nextPage == 0) {
            [self.dragToLoadDecorator setBottomViewDisabled:YES];
        } else {
            [self.dragToLoadDecorator setBottomViewDisabled:NO];
        }
        
        if (success)
            success();
        
        NSArray *resultArray = resultDict[@"Stories"];
        for (NSDictionary *dict in resultArray) {
            [BillboardPost insertBillboardPost:dict];
        }

    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Error:%@", error.localizedDescription);
        
        if (failure)
            failure();
    }];
    [request getBillboardPostsInPage:self.nextPage];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearAllData {
    [BillboardPost clearAllBillboardPosts];
}

#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self];
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragUp {
    if (_firstLoadData)
        return;
    
    [self reloadDataWithSuccessBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:NO];
    }];
}

- (void)dragToLoadDecoratorDidDragDown {
    self.nextPage = 1;
    [self reloadDataWithSuccessBlock:^{
        [self clearAllData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
        _firstLoadData = NO;
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
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

- (void)fetchedResultsControllerDidPerformFetch {
    [super fetchedResultsControllerDidPerformFetch];
    if (_firstLoadData) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

- (void)insertCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 3 == 0) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row / 3 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 3 == 0) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row / 3 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
