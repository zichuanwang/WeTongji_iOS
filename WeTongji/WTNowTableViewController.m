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
#import "WTDragToLoadDecorator.h"

#define kWeekTimeInterval (60 * 60 * 24 * 7)
// Test Data
static NSString *semesterBeginTime = @"2013-02-25T00:00:00+08:00";

@interface WTNowTableViewController()<WTDragToLoadDecoratorDataSource, WTDragToLoadDecoratorDelegate>

@property (nonatomic, assign) int weekBegin;
@property (nonatomic, assign) int weekEnd;
@property (nonatomic, assign) BOOL isTableViewFirstLoaded;
@property (nonatomic, strong) WTDragToLoadDecorator *tableViewDecorator;

@end

@implementation WTNowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
    self.tableView.scrollsToTop = NO;
    
    [self.tableViewDecorator startObservingChangesInDragToLoadScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureWeekDuration];
    [self.tableViewDecorator startObservingChangesInDragToLoadScrollView];
    
    [self loadDataFrom:[self convertToDate:self.weekBegin]
                    to:[self convertToDate:self.weekEnd]
          successBlock:^{ 
              [self.tableViewDecorator topViewLoadFinished:YES];
              [self.tableViewDecorator setBottomViewDisabled:NO];
          }
          failureBlock:^{
              [self.tableViewDecorator topViewLoadFinished:NO]; 
          }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableViewDecorator stopObservingChangesInDragToLoadScrollView];
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

- (NSDate *)convertToDate:(int)week
{
   return [[semesterBeginTime convertToDate] dateByAddingTimeInterval:week * kWeekTimeInterval];
}

- (WTDragToLoadDecorator *)tableViewDecorator
{
    if (_tableViewDecorator == nil) {
        _tableViewDecorator = [WTDragToLoadDecorator createDecoratorWithDataSource:self delegate:self];
    }
    
    return _tableViewDecorator;
}

#pragma mark - Private Method

- (void)clearAllData
{
    [Course clearAllCourses];
    [Exam clearAllExams];
    [Activity clearAllActivites];
}

- (void)configureWeekDuration
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[semesterBeginTime convertToDate]];
    self.weekBegin = interval / kWeekTimeInterval; 
    self.weekEnd = self.weekBegin + 1;
}

- (Event *)getNowEvent
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"begin_time >= %@", [NSDate date]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"begin_time" ascending:YES]];
    
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
        failureBlock:(void (^)(void))failure
{
    WTClient * client = [WTClient sharedClient];
    WTRequest * request = [WTRequest requestWithSuccessBlock:^(id responseData) {
        WTLOG(@"Get Now Data Success: %@", responseData);
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
        
        if (success) {
            success();
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
        NSLog(@"Item is %@",acitivity);
        NSLog(@"Activity is %@",cell);
        WTNowActivityCell *activityCell = (WTNowActivityCell *)cell;
        
        [activityCell configureCellWithtitle:acitivity.title
                                         time:acitivity.beginToEndTimeString
                                     location:acitivity.where
                                     imageURL:acitivity.image];
        
    } else if ([item isKindOfClass:[Course class]]){
        Course *course = (Course *)item;
        WTNowCourseCell *courseCell = (WTNowCourseCell *)cell;
        
        [courseCell configureCellWithTitle:course.name time:course.courseBeginToEndTime location:course.where];
    }
    
    Event *nowEvent = [self getNowEvent];
    switch ([item.begin_time compare:nowEvent.begin_time]) {
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
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"begin_time" ascending:YES]];
}

- (NSString *)customCellClassNameAtIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([item isKindOfClass:[Activity class]]) {
        return @"WTNowActivityCell";
    } else if ([item isKindOfClass:[Course class]]){
        return @"WTNowCourseCell";
    }
    return @"WTNowCourseCell";
}

- (NSString *)customSectionNameKeyPath {
    return nil;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [super controllerDidChangeContent:controller];
    if (!self.isTableViewFirstLoaded) {
        [self scrollToNow:NO];
        self.isTableViewFirstLoaded = TRUE;
    }
}

#pragma mark - WTDragToLoadDatasource

- (UIScrollView *)dragToLoadScrollView
{
    return self.tableView;
}

#pragma mark - WTDragToLoadDelegate

- (void)dragToLoadDecoratorDidDragDown
{
    self.weekBegin --;
    [self loadDataFrom:[self convertToDate:self.weekBegin]
                    to:[self convertToDate: self.weekBegin + 1]
          successBlock:^{
              if (!self.isTableViewFirstLoaded) {
                  [self clearAllData];
              }
              [self.tableViewDecorator topViewLoadFinished:YES];
              [self.tableViewDecorator setBottomViewDisabled:NO];
          } failureBlock:^{
              [self.tableViewDecorator topViewLoadFinished:NO];   
          }];
}

- (void)dragToLoadDecoratorDidDragUp
{
    self.weekEnd ++;
    [self loadDataFrom:[self convertToDate:self.weekEnd - 1]
                    to:[self convertToDate:self.weekEnd]
          successBlock:^{
              [self.tableViewDecorator bottomViewLoadFinished:YES];
          } failureBlock:^{
              [self.tableViewDecorator bottomViewLoadFinished:NO];
          }];
}
@end
