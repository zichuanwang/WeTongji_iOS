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
#import "WTCommonConstant.h"
#import "User.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "NSString+WTAddition.h"

#define FI_CELL_FULL_HEIGHT                     120.0f
#define FI_CELL_BUTTON_CONTAINER_VIEW_HEIGHT    50.0f
#define FI_CELL_CONTENT_LABEL_WIDTH             232.0f
#define FI_CELL_CONTENT_LABEL_ORIGINAL_HEIGHT   18.0f
#define FI_CELL_CONTENT_LABEL_LINE_SPACING      8.0f

@interface WTNotificationFriendInvitationCell()

@end

@implementation WTNotificationFriendInvitationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Class methods

+ (CGFloat)cellHeightWithNotificationObject:(FriendInvitationNotification *)notification {
    NSString *contentString = [WTNotificationFriendInvitationCell generateNotificationContentStringWithSenderName:notification.sender.name];
    CGFloat contentLabelRealHeight = [WTNotificationFriendInvitationCell calculateLabelHeightWithText:contentString font:[UIFont boldSystemFontOfSize:14.0f] labelWidth:FI_CELL_CONTENT_LABEL_WIDTH];
    CGFloat contentLabelGrowHeight = contentLabelRealHeight - FI_CELL_CONTENT_LABEL_ORIGINAL_HEIGHT;
    if (notification.accepted.boolValue) {
        return FI_CELL_FULL_HEIGHT - FI_CELL_BUTTON_CONTAINER_VIEW_HEIGHT + contentLabelGrowHeight;
    } else {
        return FI_CELL_FULL_HEIGHT + contentLabelGrowHeight;
    }
}

+ (NSMutableAttributedString *)generateNotificationContentAttributedStringWithSenderName:(NSString *)senderName {
    NSMutableAttributedString* senderNameString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ ", senderName]];
    [senderNameString setTextBold:YES range:NSMakeRange(0, senderNameString.length)];
    [senderNameString setTextColor:[UIColor whiteColor]];
    [senderNameString setFont:[UIFont boldSystemFontOfSize:14.0f]];
    NSMutableAttributedString* messageContentString = [NSMutableAttributedString attributedStringWithString:NSLocalizedString(@"wants to be in your friend list.", nil)];
    [messageContentString setTextColor:WTNotificationCellLightGrayColor];
    [messageContentString setFont:[UIFont systemFontOfSize:14.0f]];
    [messageContentString insertAttributedString:senderNameString atIndex:0];
    
    [messageContentString modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.lineSpacing = FI_CELL_CONTENT_LABEL_LINE_SPACING;
    }];
    
    return messageContentString;
}

+ (NSString *)generateNotificationContentStringWithSenderName:(NSString *)senderName {
    return [NSString stringWithFormat:@"%@ %@", senderName, NSLocalizedString(@"wants to be in your friend list.", nil)];
}

+ (CGFloat)calculateLabelHeightWithText:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)labelWidth {
    CGSize realSize = [text sizeWithFont:font];
    float lineNumber = ceilf(realSize.width / labelWidth);
    CGFloat resultHeight = realSize.height * lineNumber + FI_CELL_CONTENT_LABEL_LINE_SPACING * (lineNumber - 1);
    return resultHeight;
}

#pragma mark - UI methods

- (void)hideButtons:(BOOL)animated {
    if (animated) {
        UIViewAutoresizing notificationContentLabelResizing = self.notificationContentLabel.autoresizingMask;
        UIViewAutoresizing timeLabelResizing = self.timeLabel.autoresizingMask;
        
        self.notificationContentLabel.autoresizingMask = self.avatarContainerView.autoresizingMask;
        self.timeLabel.autoresizingMask = self.avatarContainerView.autoresizingMask;
        
        [self.buttonContainerView fadeOutWithCompletion:^{
            self.notificationContentLabel.autoresizingMask = notificationContentLabelResizing;
            self.timeLabel.autoresizingMask = timeLabelResizing;
        }];
    }
    else {
        self.buttonContainerView.alpha = 0;
    }
}

- (void)showButtons {
    self.buttonContainerView.alpha = 1;
}

- (void)showAcceptIcon {
    
}

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)self.notification;
    
    // Test code:
    friendInvitation.accepted = @(YES);
    [self hideButtons:YES];
    [self showAcceptIcon];
    [self.delegate cellHeightDidChange];
    return;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept friend invitation:%@", responseObject);
        friendInvitation.accepted = @(YES);
        [self hideButtons:YES];
        [self showAcceptIcon];
        [self.delegate cellHeightDidChange];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Accept friend invitation:%@", error.localizedDescription);
    }];
    [request acceptFriendInvitation:friendInvitation.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)self.notification;
    
    // Test code:
    [Notification deleteNotificationWithID:friendInvitation.identifier];
    return;
    
    WTRequest *request = [WTRequest requestWithSuccessBlock:^(id responseObject) {
        NSLog(@"Accept friend invitation:%@", responseObject);
        [Notification deleteNotificationWithID:friendInvitation.identifier];
    } failureBlock:^(NSError *error) {
        WTLOGERROR(@"Reject friend invitation:%@", error.localizedDescription);
    }];
    [request ignoreFriendInvitation:friendInvitation.identifier];
    [[WTClient sharedClient] enqueueRequest:request];
}

#pragma mark - UI methods

- (void)configureNotificationMessageWithSenderName:(NSString *)senderName {
    
    self.notificationContentLabel.attributedText = [WTNotificationFriendInvitationCell generateNotificationContentAttributedStringWithSenderName:senderName];
}

#pragma mark - Methods to overwrite

- (void)configureUIWithNotificaitonObject:(Notification *)notification {
    if ([notification isMemberOfClass:[FriendInvitationNotification class]]) {
        self.notification = notification;
        FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)notification;
        User *sender = friendInvitation.sender;
        [self configureNotificationMessageWithSenderName:sender.name];
        
        NSLog(@"shit:%@", [NSString yearMonthDayWeekTimeConvertFromDate:notification.sendTime]);
        self.timeLabel.text = [NSString yearMonthDayWeekTimeConvertFromDate:notification.sendTime];
        
        if (friendInvitation.accepted.boolValue) {
            [self.timeLabel resetOriginY:self.frame.size.height - 13.0f - self.timeLabel.frame.size.height];
            [self hideButtons:NO];
        } else {
            [self.timeLabel resetOriginY:self.frame.size.height - 63.0f - self.timeLabel.frame.size.height];
            [self showButtons];
        }
        
        [self resetHeight:[WTNotificationFriendInvitationCell cellHeightWithNotificationObject:friendInvitation]];
    }
}

@end
