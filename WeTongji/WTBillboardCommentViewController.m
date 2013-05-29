//
//  WTBillboardCommentViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTBillboardCommentViewController.h"
#import "WTDragToLoadDecorator.h"
#import "WTCommentCell.h"
#import "BillboardPost+Addition.h"
#import "Object+Addition.h"
#import "Comment+Addition.h"
#import "NSString+WTAddition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>

@interface WTBillboardCommentViewController () <WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@property (nonatomic, strong) BillboardPost *post;

@property (nonatomic, assign) NSInteger nextPage;

@end

@implementation WTBillboardCommentViewController

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
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

- (void)configureTableViewHeaderView {
    self.tableView.tableHeaderView = [self.dataSource commentViewControllerTableViewHeaderView];
}

#pragma mark - Logic methods

- (void)clearAllData {
    [self.post removeComments:self.post.comments];
}

- (void)reloadDataWithSuccessBlock:(void (^)(void))success
                      failureBlock:(void (^)(void))failure {
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        WTLOG(@"Get comments success:%@", responseObject);
        if (success)
            success();
        NSArray *commentsInfoArray = responseObject[@"Comments"];
        for (NSDictionary *info in commentsInfoArray) {
            Comment *comment = [Comment insertComment:info];
            WTLOG(@"comment class:%@", NSStringFromClass([comment class]));
            [self.post addCommentsObject:comment];
        }
    } failureBlock:^(NSError *error) {
        if (failure)
            failure();
        [WTErrorHandler handleError:error];
    }];
    [request getCommentsForModel:[self.post getObjectModelType] modelID:self.post.identifier page:self.nextPage];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    self.nextPage = 1;
    [self reloadDataWithSuccessBlock:^{
        [self clearAllData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

- (void)dragToLoadDecoratorDidDragUp {
    [self reloadDataWithSuccessBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator bottomViewLoadFinished:NO];
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewTopLineSectionBg"]];
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
    WTCommentCell *commentCell = (WTCommentCell *)cell;
    
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [commentCell configureViewWithIndexPath:indexPath comment:comment];
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Comment" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"SELF in %@", self.post.comments];
    
    NSSortDescriptor *createdAtDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    [request setSortDescriptors:@[createdAtDescriptor]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTCommentCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"objectClass";
}

@end
