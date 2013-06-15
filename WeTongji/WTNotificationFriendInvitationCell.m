//
//  WTNotificationFriendInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationFriendInvitationCell.h"
#import "FriendInvitationNotification.h"
#import "Notification+Addition.h"
#import "User+Addition.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"

@interface WTNotificationFriendInvitationCell()

@end

@implementation WTNotificationFriendInvitationCell

#pragma mark - Class methods

+ (NSMutableAttributedString *)generateNotificationContentAttributedStringWithSenderName:(NSString *)senderName
                                                                                accepted:(BOOL)accepted {
    NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
    [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [senderNameString setTextColor:accepted ? WTNotificationCellDarkGrayColor : [UIColor whiteColor]];
    [senderNameString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    NSMutableAttributedString* messageContentString = [NSMutableAttributedString attributedStringWithString:NSLocalizedString(@"wants to be your friend.", nil)];
    [messageContentString setTextColor:accepted ? WTNotificationCellDarkGrayColor : WTNotificationCellLightGrayColor];
    [messageContentString setFont:[UIFont systemFontOfSize:14.0f]];
    [messageContentString insertAttributedString:senderNameString atIndex:0];
    
    [messageContentString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = CONTENT_LABEL_LINE_SPACING;
    }];
    
    return messageContentString;
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)self.notification;

    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept friend invitation:%@", responseObject);
        friendInvitation.accepted = @(YES);
        [self hideButtonsAnimated:YES];
        [self showAcceptedIconAnimated:YES];
        [[WTCoreDataManager sharedManager].currentUser addFriendsObject:friendInvitation.sender];
        [self.delegate cellHeightDidChange];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Accept friend invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request acceptFriendInvitation:friendInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)self.notification;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Reject friend invitation success:%@", responseObject);
        [Notification deleteNotificationWithID:friendInvitation.identifier];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Reject friend invitation:%@", error.localizedDescription);
        [WTErrorHandler handleError:error];
    }];
    [request ignoreFriendInvitation:friendInvitation.sourceID];
    [[WTClient sharedClient] enqueueRequest:request];
}

@end
