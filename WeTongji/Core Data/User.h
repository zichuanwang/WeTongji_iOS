//
//  User.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LikeableObject.h"

@class BillboardPost, Comment, Event, LikeableObject, Notification, User;

@interface User : LikeableObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * birthPlace;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * dormBuilding;
@property (nonatomic, retain) NSString * dormDistribute;
@property (nonatomic, retain) NSString * dormRoom;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSNumber * enrollYear;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSDate * loginTime;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * motto;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * qqAccount;
@property (nonatomic, retain) NSString * sinaWeiboName;
@property (nonatomic, retain) NSString * studentNumber;
@property (nonatomic, retain) NSNumber * studyPlan;
@property (nonatomic, retain) NSString * wechatAccount;
@property (nonatomic, retain) NSNumber * friendCount;
@property (nonatomic, retain) NSNumber * likedOrganizationCount;
@property (nonatomic, retain) NSNumber * likedActivityCount;
@property (nonatomic, retain) NSNumber * likedNewsCount;
@property (nonatomic, retain) NSNumber * likedUserCount;
@property (nonatomic, retain) NSNumber * likedStarCount;
@property (nonatomic, retain) NSNumber * likedBillboardCount;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *likedObjects;
@property (nonatomic, retain) NSSet *publishedBillboardPosts;
@property (nonatomic, retain) NSSet *publishedComments;
@property (nonatomic, retain) NSSet *receivedNotifications;
@property (nonatomic, retain) NSSet *scheduledEvents;
@property (nonatomic, retain) NSSet *sentNotifications;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(User *)value;
- (void)removeFriendsObject:(User *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addLikedObjectsObject:(LikeableObject *)value;
- (void)removeLikedObjectsObject:(LikeableObject *)value;
- (void)addLikedObjects:(NSSet *)values;
- (void)removeLikedObjects:(NSSet *)values;

- (void)addPublishedBillboardPostsObject:(BillboardPost *)value;
- (void)removePublishedBillboardPostsObject:(BillboardPost *)value;
- (void)addPublishedBillboardPosts:(NSSet *)values;
- (void)removePublishedBillboardPosts:(NSSet *)values;

- (void)addPublishedCommentsObject:(Comment *)value;
- (void)removePublishedCommentsObject:(Comment *)value;
- (void)addPublishedComments:(NSSet *)values;
- (void)removePublishedComments:(NSSet *)values;

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

@end
