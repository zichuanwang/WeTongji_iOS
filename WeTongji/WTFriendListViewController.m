//
//  WTFriendListViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-11.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTFriendListViewController.h"
#import "WTResourceFactory.h"
#import "Object+Addition.h"
#import "User+Addition.h"
#import "WTUserCell.h"
#import "WTUserDetailViewController.h"
#import "WTDragToLoadDecorator.h"

@interface WTFriendListViewController () <WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *backButtonText;
@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@end

@implementation WTFriendListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _noAnimationFlag = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configureNavigationBar];
    [self configureDragToLoadDecorator];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (WTFriendListViewController *)createViewControllerWithUser:(User *)user
                                              backButtonText:(NSString *)backButtonText {
    WTFriendListViewController *vc = [[WTFriendListViewController alloc] init];
    
    vc.user = user;
    
    vc.backButtonText = backButtonText;
    
    return vc;
}

#pragma mark - Data load methods

- (void)loadMoreDataWithSuccessBlock:(void (^)(void))success
                        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get friends list: %@", responseData);
        
        if (success)
            success();
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *friendsArray = resultDict[@"Users"];
        for (NSDictionary *infoDict in friendsArray) {
            User *friend = [User insertUser:infoDict];
            [self.user addFriendsObject:friend];
        }
                
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get friends list:%@", error.localizedDescription);
        
        if (failure)
            failure();
        
        [WTErrorHandler handleError:error];
    }];
    [request getFriendsList];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)clearAllData {
    [self.user removeFriends:self.user.friends];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *cancalBarButtonItem = [WTResourceFactory createBackBarButtonWithText:self.backButtonText target:self action:@selector(didClickCancelButton:)];
    self.navigationItem.leftBarButtonItem = cancalBarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [WTResourceFactory createAddFriendBarButtonWithTarget:self action:@selector(didClickAddFriendButton:)];
    
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Friends List", nil)];
}

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self bottomActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.dragToLoadDecorator setBottomViewDisabled:YES immediately:YES];
}

#pragma mark - Actions

- (void)didClickCancelButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickAddFriendButton:(UIButton *)sender {
    
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTLOG(@"configure friend list cell at indexpath:%d", indexPath.row);
    WTUserCell *userCell = (WTUserCell *)cell;
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [userCell configureCellWithIndexPath:indexPath user:user];
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[nameDescriptor]];

    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", self.user.friends]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTUserCell";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
        [self.dragToLoadDecorator setTopViewLoading:YES];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTUserDetailViewController *vc = [WTUserDetailViewController createDetailViewControllerWithUser:user backBarButtonText:NSLocalizedString(@"Friends List", nil)];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WTDragToLoadDecoratorDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDecoratorDelegate

- (void)dragToLoadDecoratorDidDragDown {
    [self loadMoreDataWithSuccessBlock:^{
        [self clearAllData];
        [self.dragToLoadDecorator topViewLoadFinished:YES];
    } failureBlock:^{
        [self.dragToLoadDecorator topViewLoadFinished:NO];
    }];
}

@end
