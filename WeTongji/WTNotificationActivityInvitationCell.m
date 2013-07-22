//
//  WTNotificationActivityInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationActivityInvitationCell.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "ActivityInvitationNotification.h"
#import "Notification+Addition.h"
#import "Activity+Addition.h"
#import "User+Addition.h"
#import "WTCoreDataManager.h"

@implementation WTNotificationActivityInvitationCell

#pragma mark - Class methods

+ (NSMutableAttributedString *)generateNotificationContentAttributedStringWithSenderName:(NSString *)senderName
                                                                           activityTitle:(NSString *)activityTitle
                                                                                accepted:(BOOL)accepted {
    NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
    [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [senderNameString setTextColor:accepted ? WTNotificationCellDarkGrayColor : [UIColor whiteColor]];
    [senderNameString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    NSMutableAttributedString* activityTitleString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@" %@", activityTitle]];
    [activityTitleString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [activityTitleString setTextColor:accepted ? WTNotificationCellDarkGrayColor : [UIColor whiteColor]];
    [activityTitleString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    NSMutableAttributedString* messageContentString = [NSMutableAttributedString attributedStringWithString:NSLocalizedString(@"invites you to participate in.", nil)];
    [messageContentString setTextColor:accepted ? WTNotificationCellDarkGrayColor : WTNotificationCellLightGrayColor];
    [messageContentString setFont:[UIFont systemFontOfSize:14.0f]];
    [messageContentString insertAttributedString:senderNameString atIndex:0];
    [messageContentString insertAttributedString:activityTitleString atIndex:messageContentString.length - 1];
    
    [messageContentString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    return messageContentString;
}

- (void)configureTypeIconImageView {
    ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)self.notification;
    if (activityInvitation.accepted.boolValue) {
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"WTNotificationAcceptIcon"];
    } else {
        self.notificationTypeIconImageView.image = [UIImage imageNamed:@"WTNotificationQuestionIcon"];
    }
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept activity invitation:%@", responseObject);
        activityInvitation.accepted = @(YES);
        [self hideButtonsAnimated:YES];
        [self showAcceptedIconAnimated:YES];
        [self configureTypeIconImageView];
        activityInvitation.activity.scheduledByCurrentUser = YES;
        [self.delegate cellHeightDidChange];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Accept activity invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request acceptActivityInvitation:activityInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Reject activity invitation success:%@", responseObject);
        [Notification deleteNotificationWithID:activityInvitation.identifier];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Reject activity invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request ignoreActivityInvitation:activityInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    [super configureUIWithNotificaitonObject:notification];
    [self configureTypeIconImageView];
}

@end
