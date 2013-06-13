//
//  Course.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class CourseInvitationNotification;

@interface Course : Event

@property (nonatomic, retain) NSDate * courseDay;
@property (nonatomic, retain) NSNumber * credit;
@property (nonatomic, retain) NSNumber * hours;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSNumber * sectionEnd;
@property (nonatomic, retain) NSNumber * sectionStart;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * weekDay;
@property (nonatomic, retain) NSString * weekType;
@property (nonatomic, retain) NSNumber * isAudit;
@property (nonatomic, retain) NSSet *relatedCourseInvitations;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addRelatedCourseInvitationsObject:(CourseInvitationNotification *)value;
- (void)removeRelatedCourseInvitationsObject:(CourseInvitationNotification *)value;
- (void)addRelatedCourseInvitations:(NSSet *)values;
- (void)removeRelatedCourseInvitations:(NSSet *)values;

@end
