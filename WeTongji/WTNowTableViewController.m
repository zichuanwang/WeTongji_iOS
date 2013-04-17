//
//  WTNowTableViewController.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowTableViewController.h"
#import "Exam+Addition.h"
#import "Course+Addition.h"
#import "Activity+Addition.h"
#import "NSUserDefaults+WTAddition.h"
#import "NSString+WTAddition.h"
#import "WTNowActivityCell.h"
#import "WTNowCourseCell.h"
#import "Event+Addition.h"
#import "NSNotificationCenter+WTAddition.h"
#import "WTDragToLoadDecorator.h"

@interface WTNowTableViewController () <WTDragToLoadDecoratorDelegate, WTDragToLoadDecoratorDataSource>

@property (nonatomic, strong) WTDragToLoadDecorator *dragToLoadDecorator;

@end

@implementation WTNowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];
    [self configureDragToLoadDecorator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.dragToLoadDecorator stopObservingChangesInDragToLoadScrollView];
}

#pragma mark - Public methods

- (void)scrollToNow:(BOOL)animated {
    Event *nowEvent = [self getNowEvent];
    if (nowEvent) {
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:nowEvent];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

- (void)changeCurrentUser {
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

#pragma mark - Properties

- (void)setWeekNumber:(NSUInteger)weekNumber {
    _weekNumber = weekNumber;
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

#pragma mark - Logic Method

- (NSDate *)convertWeekNumberToDate:(NSUInteger)weekNumber {
    return [[semesterBeginTime convertToDate] dateByAddingTimeInterval:weekNumber * WEEK_TIME_INTERVAL];
}

- (void)clearAllData {
    [Course clearAllCourses];
    [Exam clearAllExams];
    [Activity clearAllActivites];
}

- (Event *)getNowEvent {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@) AND (endTime >= %@)", [WTCoreDataManager sharedManager].currentUser.scheduledEvents, [NSDate date]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"endTime" ascending:YES]];
    
    NSArray *matches = [[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    if ([matches count] == 0) {
        return nil;
    } else {
        return [matches objectAtIndex:0];
    }
}

- (void)loadDataFrom:(NSDate *)fromDate
                  to:(NSDate *)toDate
        successBlock:(void (^)(void))success
        failureBlock:(void (^)(void))failure {
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Now Data Success: %@", responseData);
        
        if (success) {
            success();
        }
        
        User *currentUser = [WTCoreDataManager sharedManager].currentUser;
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *activitiesArray = resultDict[@"Activities"];
        for (NSDictionary *dict in activitiesArray) {
            Activity *activity= [Activity insertActivity:dict];
            [currentUser addScheduledEventsObject:activity];
        }
        
        NSArray *coursesArray = resultDict[@"CourseInstances"];
        for (NSDictionary *dict in coursesArray) {
            Course *course = [Course insertCourse:dict];
            [currentUser addScheduledEventsObject:course];
        }
        
        NSArray *examsArray = resultDict[@"Exams"];
        for (NSDictionary *dict in examsArray) {
            Exam *exam = [Exam insertExam:dict];
            [currentUser addScheduledEventsObject:exam];
        }
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get NowData Error:%@", error.localizedDescription);
        if (failure) {
            failure();
        }
    }];    
    [request getScheduleWithBeginDate:fromDate endDate:toDate];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureDragToLoadDecorator {
    self.dragToLoadDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self];
    [self.dragToLoadDecorator setBottomViewDisabled:YES];
    [self.dragToLoadDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.scrollsToTop = NO;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView *bgImageView = nil;
    if (section == 0) {
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewSectionBg"]];
    } else {
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WTTableViewTopLineSectionBg"]];
    }
    
    CGFloat sectionHeaderHeight = bgImageView.frame.size.height;
    
    Event *firstEventInSection = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    UILabel *weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, tableView.bounds.size.width, sectionHeaderHeight)];
    weekDayLabel.text = [NSString weekConvertFromDate:firstEventInSection.beginTime];
    weekDayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    weekDayLabel.textColor = [UIColor colorWithRed:131.0f / 255 green:131.0f / 255 blue:131.0f / 255 alpha:1.0f];
    weekDayLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *yearMonthDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width - 10.0f, sectionHeaderHeight)];
    yearMonthDayLabel.textAlignment = NSTextAlignmentRight;
    yearMonthDayLabel.text = [NSString yearMonthDayConvertFromDate:firstEventInSection.beginTime];
    yearMonthDayLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    yearMonthDayLabel.textColor = [UIColor colorWithRed:131.0f / 255 green:131.0f / 255 blue:131.0f / 255 alpha:1.0f];
    yearMonthDayLabel.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:bgImageView.frame];
    [headerView addSubview:bgImageView];
    [headerView addSubview:weekDayLabel];
    [headerView addSubview:yearMonthDayLabel];
    
    return headerView;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    WTNowBaseCell *nowCell = (WTNowBaseCell *)cell;
    [nowCell configureCellWithEvent:item];
    
    NSDate *nowDate = [NSDate date];
    if ([nowDate compare:item.beginTime] == NSOrderedAscending) {
        [nowCell updateCellStatus:WTNowBaseCellTypeNormal];

    } else if ([nowDate compare:item.endTime] == NSOrderedDescending) {
        [nowCell updateCellStatus:WTNowBaseCellTypePast];
    } else {
        [nowCell updateCellStatus:WTNowBaseCellTypeNow];
    }
}

- (void)configureRequest:(NSFetchRequest *)request {
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(SELF in %@) AND (beginTime >= %@) AND (beginTime <= %@)", [WTCoreDataManager sharedManager].currentUser.scheduledEvents, [self convertWeekNumberToDate:self.weekNumber - 1], [self convertWeekNumberToDate:self.weekNumber]];
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([item isKindOfClass:[Activity class]]) {
        return @"WTNowActivityCell";
    } else if ([item isKindOfClass:[Course class]]){
        return @"WTNowCourseCell";
    }
    return nil;
}

- (NSString *)customSectionNameKeyPath {
    return @"beginDay";
}

- (void)fetchedResultsControllerDidPerformFetch {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
        if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
            [self.dragToLoadDecorator setTopViewLoading:YES];            
        }
    });
}

#pragma mark - WTDragToLoadDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

#pragma mark - WTDragToLoadDelegate

- (void)dragToLoadDecoratorDidDragDown {
    NSDate *fromDate = [self convertWeekNumberToDate:self.weekNumber - 1];
    NSDate *toDate = [self convertWeekNumberToDate:self.weekNumber];
    [self loadDataFrom:fromDate
                    to:toDate
          successBlock:^{
              [Event clearCurrentUserScheduledEventsFrom:fromDate to:toDate];
              [self.dragToLoadDecorator topViewLoadFinished:YES];
          } failureBlock:^{
              [self.dragToLoadDecorator topViewLoadFinished:NO];
          }];
}

@end
