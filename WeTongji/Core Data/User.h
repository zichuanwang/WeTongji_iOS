//
//  User.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class Notification;

@interface User : Object

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * student_number;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSNumber * study_plan;
@property (nonatomic, retain) NSString * qq_account;
@property (nonatomic, retain) NSNumber * enroll_year;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * avatar_link;
@property (nonatomic, retain) NSString * birth_place;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * email_address;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSDate * login_time;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSString * sina_weibo_name;
@property (nonatomic, retain) NSString * wechat_account;
@property (nonatomic, retain) NSSet *sent_notifications;
@property (nonatomic, retain) NSSet *received_notifications;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addSent_notificationsObject:(Notification *)value;
- (void)removeSent_notificationsObject:(Notification *)value;
- (void)addSent_notifications:(NSSet *)values;
- (void)removeSent_notifications:(NSSet *)values;

- (void)addReceived_notificationsObject:(Notification *)value;
- (void)removeReceived_notificationsObject:(Notification *)value;
- (void)addReceived_notifications:(NSSet *)values;
- (void)removeReceived_notifications:(NSSet *)values;

@end
