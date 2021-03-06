//
//  WTTeamMemberViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTTeamMemberViewController.h"
#import "WTResourceFactory.h"
#import "User+Addition.h"
#import "WTUserDetailViewController.h"
#import "WTUserCell.h"
#import "UIApplication+WTAddition.h"
#import "UIView+TableViewSectionHeader.h"

@interface WTTeamMemberViewController ()

@property (nonatomic, strong) NSArray *memberStudentNoArray;
@property (nonatomic, strong) NSArray *memberIDArray;

@end

@implementation WTTeamMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.memberStudentNoArray = @[@"1235145", @"092932", @"092969", @"093011", @"092988", @"082915"];
        self.memberIDArray = @[@"201211272254565", @"201301231200313", @"201205161608512", @"201205162002093", @"201301052111477", @"201209231418181"];
        _noAnimationFlag = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureNavigationBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)configureMemberTitle:(User *)member {
    if ([member.studentNumber isEqualToString:@"1235145"]) member.note = @"0Director";
    else if ([member.studentNumber isEqualToString:@"093011"]) member.note = @"3Project Manager";
    else if ([member.studentNumber isEqualToString:@"092932"]) member.note = @"1Designer";
    else member.note = @"2Developer";
}

- (void)loadTeamMemberData {
    for (int i = 0; i < self.memberIDArray.count; i++) {
        NSString *userID = self.memberIDArray[i];
        User *member = [User userWithID:userID];
        if (!member) {
            WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
                NSDictionary *responseDict = (NSDictionary *)responseObject;
                NSArray *userInfoArray = responseDict[@"Users"];
                NSDictionary *userInfo = userInfoArray.lastObject;
                User *newMember = [User insertUser:userInfo];
                [self configureMemberTitle:newMember];
            } failureBlock:^(NSError *error) {
                
            }];
            NSInteger searchUserCategory = 1;
            NSString *studentNo = self.memberStudentNoArray[i];
            [request getSearchResultInCategory:searchUserCategory keyword:studentNo];
            [[WTClient sharedClient] enqueueRequest:request];
        } else {
            [self configureMemberTitle:member];
        }
    }
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WTLOG(@"configure friend list cell at indexpath:%d", indexPath.row);
    WTUserCell *userCell = (WTUserCell *)cell;
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [userCell configureCellWithIndexPath:indexPath user:user];
}

- (void)configureFetchRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    NSSortDescriptor *titleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"note" ascending:YES];
    NSSortDescriptor *pinyinDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pinyin" ascending:YES];
    [request setSortDescriptors:@[titleDescriptor, pinyinDescriptor]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"studentNumber in %@", self.memberStudentNoArray]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    return @"WTUserCell";
}

- (NSString *)customSectionNameKeyPath {
    return @"note";
}

- (void)fetchedResultsControllerDidPerformFetch {
    if ([self.fetchedResultsController.sections.lastObject numberOfObjects] < self.memberStudentNoArray.count) {
        [self loadTeamMemberData];
    }
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI methods

- (void)configureNavigationBar {
    UIBarButtonItem *backBarButtonItem = [WTResourceFactory createBackBarButtonWithText:NSLocalizedString(@"Setting", nil) target:self action:@selector(didClickBackButton:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    // self.navigationItem.rightBarButtonItem = [WTResourceFactory createAddFriendBarButtonWithTarget:self action:@selector(didClickAddFriendButton:)];
    
    self.navigationItem.titleView = [WTResourceFactory createNavigationBarTitleViewWithText:NSLocalizedString(@"Team Members", nil)];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionName = NSLocalizedString([self.fetchedResultsController.sections[section] name], nil);
    return [UIView sectionHeaderViewWithSectionName:sectionName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([WTCoreDataManager sharedManager].currentUser == user) {
        [[UIApplication sharedApplication].rootTabBarController clickTabWithName:WTRootTabBarViewControllerMe];
        return;
    }
    
    WTUserDetailViewController *vc = [WTUserDetailViewController createDetailViewControllerWithUser:user backBarButtonText:NSLocalizedString(@"Team Members", nil)];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
