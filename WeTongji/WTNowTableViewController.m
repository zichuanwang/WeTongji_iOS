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
#define kDragDownToLoadMoreDataOffset 50
#define kDragUpToLoadMoreDataOffset 350
// Test Data
static NSString *semesterBeginTime = @"2013-02-25T00:00:00+08:00";

@interface WTNowTableViewController()

@property (nonatomic, assign) int weekBegin;
@property (nonatomic, assign) int weekEnd;
@property (nonatomic, readonly) NSDate *loadNowDataBeginDate;
@property (nonatomic, readonly) NSDate *loadNowDataEndDate;
@property (nonatomic, strong) WTPullTableHeaderView *pullTableHeaderView;

- (Event *)getNowEvent;
- (void)configureWeekDuration;

@end

@implementation WTNowTableViewController
@synthesize weekBegin = _weekBegin;
@synthesize weekEnd = _weekEnd;
@synthesize loadNowDataBeginDate = _loadNowDataBeginDate;
@synthesize loadNowDataEndDate = _loadNowDataEndDate;
@synthesize pullTableHeaderView = _pullTableHeaderView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBackgroundUnit"]];
    self.tableView.scrollsToTop = NO;
    [self.tableView addSubview:self.pullTableHeaderView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [self configureWeekDuration];
    [self loadData];
}

#pragma mark - Override Getter Method

- (NSDate *)loadNowDataBeginDate
{
    _loadNowDataBeginDate = [[semesterBeginTime convertToDate] dateByAddingTimeInterval:self.weekBegin * kWeekTimeInterval];
    NSLog(@"Load Start From is %@", _loadNowDataBeginDate);
    return _loadNowDataBeginDate;
}

- (NSDate *)loadNowDataEndDate
{
    _loadNowDataEndDate = [[semesterBeginTime convertToDate] dateByAddingTimeInterval:self.weekEnd * kWeekTimeInterval];
    NSLog(@"Load End From is %@", _loadNowDataEndDate);
    return _loadNowDataEndDate;
}

- (WTPullTableHeaderView *)pullTableHeaderView
{
    if (_pullTableHeaderView == nil) {
        _pullTableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"WTPullTableHeaderView" owner:self options:nil] objectAtIndex:0];
        [_pullTableHeaderView resetOriginY:-_pullTableHeaderView.bounds.size.height];
        _pullTableHeaderView.delegate = self;
    }
    
    return _pullTableHeaderView;
}

#pragma mark - Private Method

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
        
        [self.pullTableHeaderView pullTableHeaderViewDidFinishingLoading:self.tableView];
    } failureBlock:^(NSError * error) {
        WTLOGERROR(@"Get NowData Error:%@", error.localizedDescription);
        [self.pullTableHeaderView pullTableHeaderViewDidFinishingLoading:self.tableView];
    }];    
    [request getScheduleWithBeginDate:self.loadNowDataBeginDate endDate:self.loadNowDataEndDate];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (scrollView.contentOffset.y < - kDragDownToLoadMoreDataOffset) {
//        self.weekBegin --;
//        [self loadData];
//    } else if (scrollView.contentOffset.y + kDragUpToLoadMoreDataOffset >= scrollView.contentSize.height) {
//        self.weekEnd ++;
//        [self loadData];
//    }
    [self.pullTableHeaderView pullTableHeaderViewDidEndDragging:scrollView];
}

#pragma mark - WTPullTableHeaderViewDelegate

- (void)pullToLoadData
{
    self.weekBegin --;
    [self loadData];
}

@end
