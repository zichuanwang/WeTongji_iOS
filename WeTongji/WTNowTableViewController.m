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
#import "Event.h"
#import "NSNotificationCenter+WTAddition.h"

@interface WTNowTableViewController ()

@end

@implementation WTNowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureTableView];    
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
    if (_weekNumber != weekNumber) {
        _weekNumber = weekNumber;
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
    }
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

//- (void)configureWeekDuration {
//    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[semesterBeginTime convertToDate]];
//    self.weekBegin = interval / WEEK_TIME_INTERVAL; 
//    self.weekEnd = self.weekBegin + 1;
//}

- (Event *)getNowEvent {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"beginTime >= %@", [NSDate date]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
    
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

- (void)configureTableView {
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.scrollsToTop = NO;
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([item isKindOfClass:[Activity class]]) {
        Activity *acitivity = (Activity *)item;
        WTNowActivityCell *activityCell = (WTNowActivityCell *)cell;
        
        [activityCell configureCellWithTitle:acitivity.what
                                         time:acitivity.beginToEndTimeString
                                     location:acitivity.where
                                     imageURL:acitivity.image];
        
    } else if ([item isKindOfClass:[Course class]]){
        Course *course = (Course *)item;
        WTNowCourseCell *courseCell = (WTNowCourseCell *)cell;
        
        [courseCell configureCellWithTitle:course.what
                                      time:course.beginTimeString
                                  location:course.where];
    }
    
    Event *nowEvent = [self getNowEvent];
    NSDate *nowTime = nowEvent == nil ? [NSDate date] : nowEvent.beginTime;
    switch ([item.beginTime compare:nowTime]) {
        case NSOrderedSame:
            [(WTNowBaseCell *)cell updateCellStatus:WTNowBaseCellTypeNow];
            break;
        case NSOrderedAscending:
            [(WTNowBaseCell *)cell updateCellStatus:WTNowBaseCellTypePast];
            break;
        case NSOrderedDescending:
            [(WTNowBaseCell *)cell updateCellStatus:WTNowBaseCellTypeNormal];
            break;
        default:
            break;
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

- (void)fetchedResultsControllerDidPerformFetch {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_current_queue(), ^{
        if ([self.fetchedResultsController.sections.lastObject numberOfObjects] == 0) {
            [self loadDataFrom:[self convertWeekNumberToDate:self.weekNumber - 1] to:[self convertWeekNumberToDate:self.weekNumber] successBlock:^{
                
            } failureBlock:^{
                
            }];
            //[self.dragToLoadDecorator setTopViewLoading:YES];
        }
    });
}

#pragma mark - WTDragToLoadDataSource

- (UIScrollView *)dragToLoadScrollView {
    return self.tableView;
}

//#pragma mark - WTDragToLoadDelegate
//
//- (void)dragToLoadDecoratorDidDragDown {
//    self.weekBegin --;
//    [self loadDataFrom:[self convertToDate:self.weekBegin]
//                    to:[self convertToDate:self.weekBegin + 1]
//          successBlock:^{
//              [self.tableViewDecorator topViewLoadFinished:YES];
//              [self.tableViewDecorator setBottomViewDisabled:NO];
//          } failureBlock:^{
//              [self.tableViewDecorator topViewLoadFinished:NO];   
//          }];
//}
//
//- (void)dragToLoadDecoratorDidDragUp {
//    self.weekEnd ++;
//    [self loadDataFrom:[self convertToDate:self.weekEnd - 1]
//                    to:[self convertToDate:self.weekEnd]
//          successBlock:^{
//              [self.tableViewDecorator bottomViewLoadFinished:YES];
//          } failureBlock:^{
//              [self.tableViewDecorator bottomViewLoadFinished:NO];
//          }];
//}

@end
