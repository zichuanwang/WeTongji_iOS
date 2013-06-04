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

@implementation WTNotificationActivityInvitationCell

#pragma mark - Class methods

+ (NSMutableAttributedString *)generateNotificationContentAttributedStringWithSenderName:(NSString *)senderName
                                                                           activityTitle:(NSString *)activityTitle {
    NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
    [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [senderNameString setTextColor:[UIColor whiteColor]];
    [senderNameString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    NSMutableAttributedString* activityTitleString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@" %@", activityTitle]];
    [activityTitleString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [activityTitleString setTextColor:[UIColor whiteColor]];
    [activityTitleString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    
    NSMutableAttributedString* messageContentString = [NSMutableAttributedString attributedStringWithString:NSLocalizedString(@"invites you to", nil)];
    [messageContentString setTextColor:WTNotificationCellLightGrayColor];
    [messageContentString setFont:[UIFont systemFontOfSize:14.0f]];
    [messageContentString insertAttributedString:senderNameString atIndex:0];
    [messageContentString insertAttributedString:activityTitleString atIndex:messageContentString.length];
    
    [messageContentString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    return messageContentString;
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept activity invitation:%@", responseObject);
        activityInvitation.accepted = @(YES);
        [self hideButtonsAnimated:YES];
        [self showAcceptedIconAnimated:YES];
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

@end
