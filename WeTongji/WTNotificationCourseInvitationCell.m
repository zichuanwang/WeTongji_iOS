//
//  WTNotificationCourseInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationCourseInvitationCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "CourseInvitationNotification.h"
#import "Notification+Addition.h"
#import "Course+Addition.h"
#import "User+Addition.h"
#import "WTCoreDataManager.h"

@implementation WTNotificationCourseInvitationCell

#pragma mark - Class methods

+ (NSMutableAttributedString *)generateNotificationContentAttributedStringWithSenderName:(NSString *)senderName
                                                                             courseTitle:(NSString *)courseTitle {
    NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
    [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [senderNameString setTextColor:[UIColor whiteColor]];
    [senderNameString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    NSMutableAttributedString* courseTitleString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@" %@", courseTitle]];
    [courseTitleString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [courseTitleString setTextColor:[UIColor whiteColor]];
    [courseTitleString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    NSMutableAttributedString* messageContentString = [NSMutableAttributedString attributedStringWithString:NSLocalizedString(@"invites you to audit.", nil)];
    [messageContentString setTextColor:WTNotificationCellLightGrayColor];
    [messageContentString setFont:[UIFont systemFontOfSize:14.0f]];
    [messageContentString insertAttributedString:senderNameString atIndex:0];
    [messageContentString insertAttributedString:courseTitleString atIndex:messageContentString.length - 1];
    
    [messageContentString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    return messageContentString;
}

- (void)configureTypeIconImageView {
    CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)self.notification;
    if (courseInvitation.accepted.boolValue) {
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"WTNotificationAcceptIcon"];
    } else {
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"WTNotificationQuestionIcon"];
    }
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept course invitation:%@", responseObject);
        courseInvitation.accepted = @(YES);
        [self hideButtonsAnimated:YES];
        [self showAcceptedIconAnimated:YES];
        [self configureTypeIconImageView];
        // TODO
        // [[WTCoreDataManager sharedManager].currentUser addScheduledEventsObject:courseInvitation.course];
        [self.delegate cellHeightDidChange];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Accept course invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request acceptCourseInvitation:courseInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Reject course invitation success:%@", responseObject);
        [Notification deleteNotificationWithID:courseInvitation.identifier];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Reject course invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request ignoreCourseInvitation:courseInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    [super configureUIWithNotificaitonObject:notification];
    [self configureTypeIconImageView];
}

@end
