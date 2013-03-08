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

@interface WTNowTableViewController()

- (Event *)getNowEvent;

@end

@implementation WTNowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
    
    self.tableView.scrollsToTop = NO;
    
    [self loadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView resetHeight:self.view.frame.size.height];
}

#pragma mark - Private Method

- (Event *)getNowEvent
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"begin_time >= %@", [NSDate date]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"begin_time" ascending:YES]];
    NSArray *matches = [[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:nil];
    
    return [matches objectAtIndex:0];
}

- (void)loadData {
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
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get NowData Error:%@", error.localizedDescription);
    }];    
     // Test Data
    NSString *begin = @"2013-02-25T00:00:00+08:00";
    NSDate *beginDay = [begin convertToDate];
    NSDate *endDay = [beginDay dateByAddingTimeInterval:60 * 60 * 24 * 7 * 20];
    [request getScheduleWithBeginDate:beginDay endDate:endDay];
    [client enqueueRequest:request];
}

#pragma mark - CoreDataTableViewController methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Event *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([item isKindOfClass:[Activity class]]) {
        Activity *acitivity = (Activity *)item;
        WTNowActivityCell *activityCell = (WTNowActivityCell *)cell;
        
        [activityCell configureCellWithtitle:acitivity.title
                                         time:acitivity.beginToEndTimeString
                                     location:acitivity.location
                                     imageURL:acitivity.image];
        
    } else if ([item isKindOfClass:[Course class]]){
        Course *course = (Course *)item;
        WTNowCourseCell *courseCell = (WTNowCourseCell *)cell;
        
        [courseCell configureCellWithTitle:course.name time:course.courseBeginToEndTime location:course.location];
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


@end
