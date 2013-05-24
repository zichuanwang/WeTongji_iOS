//
//  User.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-25.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class BillboardComment, Event, Notification, User;

@interface User : Object

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * birthPlace;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSNumber * enrollYear;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSDate * loginTime;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * qqAccount;
@property (nonatomic, retain) NSString * sinaWeiboName;
@property (nonatomic, retain) NSString * studentNumber;
@property (nonatomic, retain) NSNumber * studyPlan;
@property (nonatomic, retain) NSString * wechatAccount;
@property (nonatomic, retain) NSSet *billboardComments;
@property (nonatomic, retain) NSSet *receivedNotifications;
@property (nonatomic, retain) NSSet *scheduledEvents;
@property (nonatomic, retain) NSSet *sentNotifications;
@property (nonatomic, retain) NSSet *friends;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addBillboardCommentsObject:(BillboardComment *)value;
- (void)removeBillboardCommentsObject:(BillboardComment *)value;
- (void)addBillboardComments:(NSSet *)values;
- (void)removeBillboardComments:(NSSet *)values;

- (void)addReceivedNotificationsObject:(Notification *)value;
- (void)removeReceivedNotificationsObject:(Notification *)value;
- (void)addReceivedNotifications:(NSSet *)values;
- (void)removeReceivedNotifications:(NSSet *)values;

- (void)addScheduledEventsObject:(Event *)value;
- (void)removeScheduledEventsObject:(Event *)value;
- (void)addScheduledEvents:(NSSet *)values;
- (void)removeScheduledEvents:(NSSet *)values;

- (void)addSentNotificationsObject:(Notification *)value;
- (void)removeSentNotificationsObject:(Notification *)value;
- (void)addSentNotifications:(NSSet *)values;
- (void)removeSentNotifications:(NSSet *)values;

- (void)addFriendsObject:(User *)value;
- (void)removeFriendsObject:(User *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
