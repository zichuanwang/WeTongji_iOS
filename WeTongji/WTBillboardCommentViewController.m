//
//  WTBillboardCommentViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardCommentViewController.h"
#import "WTDragToLoadDecorator.h"
#import "WTBillboardCommentCell.h"
#import "BillboardPost.h"
#import "NSString+WTAddition.h"

@interface WTBillboardCommentViewController () <WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, weak) BillboardPost *post;

@end

@implementation WTBillboardCommentViewController

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
    [self configureTableViewHeaderView];
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

+ (WTBillboardCommentViewController *)createCommentViewControllerWithBillboardPost:(BillboardPost *)post
                                                                        dataSource:(id<WTBillboardCommentViewControllerDataSource>)dataSource {
    WTBillboardCommentViewController *result = [[WTBillboardCommentViewController alloc] init];
    result.post = post;
    result.dataSource = dataSource;
    return result;
}

#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self];
    [self.dragToLoadDecorator setBottomViewDisabled:YES];
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)configureTableViewHeaderView {
    self.tableView.tableHeaderView = [self.dataSource commentViewControllerTableViewHeaderView];
}

#pragma mark - Logic methods

- (void)reloadDataWithSuccessBlock:(void (^)(void))success
                      failureBlock:(void (^)(void))failure {
    if (failure)
        failure();
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    [self reloadDataWithSuccessBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    CGFloat sectionHeaderHeight = bgImageView.frame.size.height;
    
    NSUInteger numberOfComments = [self.fetchedResultsController.sections[section] numberOfObjects];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, sectionHeaderHeight)];
    label.text = [NSString commentCountStringConvertFromCountNumber:@(numberOfComments)];
    label.font = [UIFont boldSystemFontOfSize:12.0f];
    label.textColor = WTSectionHeaderViewLightGrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, sectionHeaderHeight)];
    [headerView addSubview:bgImageView];
    [headerView addSubview:label];
    
    return headerView;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTBillboardCommentCell *commentCell = (WTBillboardCommentCell *)cell;
    
    BillboardComment *comment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [commentCell configureViewWithBillboardComment:comment];
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"BillboardComment" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"SELF in %@", self.post.comments];
    
    NSSortDescriptor *createdAtDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    [request setSortDescriptors:@[createdAtDescriptor]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTBillboardCommentCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"belongTo";
}

@end
