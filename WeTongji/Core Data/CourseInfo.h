//
//  CourseInfo.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class Course, CourseInvitationNotification;

@interface CourseInfo : Object

@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSNumber * credit;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSNumber * hours;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *instances;
@property (nonatomic, retain) NSSet *relatedCourseInvitations;
@property (nonatomic, retain) NSSet *timetables;
@end

@interface CourseInfo (CoreDataGeneratedAccessors)

- (void)addInstancesObject:(Course *)value;
- (void)removeInstancesObject:(Course *)value;
- (void)addInstances:(NSSet *)values;
- (void)removeInstances:(NSSet *)values;

- (void)addRelatedCourseInvitationsObject:(CourseInvitationNotification *)value;
- (void)removeRelatedCourseInvitationsObject:(CourseInvitationNotification *)value;
- (void)addRelatedCourseInvitations:(NSSet *)values;
- (void)removeRelatedCourseInvitations:(NSSet *)values;

- (void)addTimetablesObject:(NSManagedObject *)value;
- (void)removeTimetablesObject:(NSManagedObject *)value;
- (void)addTimetables:(NSSet *)values;
- (void)removeTimetables:(NSSet *)values;

@end
