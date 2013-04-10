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

#define kWeekTimeInterval (60 * 60 * 24 * 7)
// Test Data
static NSString *semesterBeginTime = @"2013-02-25T00:00:00+08:00";

@interface WTNowTableViewController()

@property (nonatomic, assign) int weekBegin;
@property (nonatomic, assign) int weekEnd;

@end

@implementation WTNowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
    self.tableView.scrollsToTop = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureWeekDuration];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)scrollToNow:(BOOL)animated
{
    Event *nowEvent = [self getNowEvent];
    if (nowEvent != NULL) {
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:nowEvent];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:animated];
    }
}

#pragma mark - Override Getter Method

- (NSDate *)convertToDate:(int)week {
   return [[semesterBeginTime convertToDate] dateByAddingTimeInterval:week * kWeekTimeInterval];
}

#pragma mark - Private Method

- (void)clearAllData {
    [Course clearAllCourses];
    [Exam clearAllExams];
    [Activity clearAllActivites];
}

- (void)configureWeekDuration {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[semesterBeginTime convertToDate]];
    self.weekBegin = interval / kWeekTimeInterval; 
    self.weekEnd = self.weekBegin + 1;
}

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
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Now Data Success: %@", responseData);
        
        if (success) {
            success();
        }
        
        NSDictionary *resultDict = (NSDictionary *)responseData;
        NSArray *activitiesArray = resultDict[@"Activities"];
        for (NSDictionary *dict in activitiesArray) {
            [Activity insertActivity:dict];
        }
        
        NSArray *coursesArray = resultDict[@"CourseInstances"];
        for (NSDictionary *dict in coursesArray) {
            [Course insertCourse:dict];
        }
        
        NSArray *examsArray = resultDict[@"Exams"];
        for (NSDictionary *dict in examsArray) {
            [Exam insertExam:dict];
        }
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get NowData Error:%@", error.localizedDescription);
        if (failure) {
            failure();
        }
    }];    
    [request getScheduleWithBeginDate:fromDate endDate:toDate];
    [client enqueueRequest:request];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([item isKindOfClass:[Activity class]]) {
        Activity *acitivity = (Activity *)item;
        WTNowActivityCell *activityCell = (WTNowActivityCell *)cell;
        
        [activityCell configureCellWithtitle:acitivity.what
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
    request.predicate = [NSPredicate predicateWithFormat:@"SELF in %@", [WTCoreDataManager sharedManager].currentUser.scheduledEvents];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([item isKindOfClass:[Activity class]]) {
        return @"WTNowActivityCell";
    } else if ([item isKindOfClass:[Course class]]){
        return @"WTNowCourseCell";
    } else if ([item isKindOfClass:[Exam class]]) {
        return @"WTNowCourseCell";
    }
    return @"WTNowActivityCell";
}

#pragma mark - WTDragToLoadDatasource

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
