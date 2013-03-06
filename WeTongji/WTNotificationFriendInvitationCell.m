//
//  WTNotificationFriendInvitationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNotificationFriendInvitationCell.h"
#import "FriendInvitationNotification.h"
#import "WTCommonConstant.h"
#import "User.h"

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

#pragma mark - Actions

- (IBAction)didClickAcceptButton:(UIButton *)sender {
    FriendInvitationNotification *friendInvitation = (FriendInvitationNotification *)self.notification;
    friendInvitation.accepted = @(YES);
    
    UIViewAutoresizing notificationContentLabelResizing = self.notificationContentLabel.autoresizingMask;
    UIViewAutoresizing timeLabelResizing = self.timeLabel.autoresizingMask;
    
    self.notificationContentLabel.autoresizingMask = self.avatarContainerView.autoresizingMask;
    self.timeLabel.autoresizingMask = self.avatarContainerView.autoresizingMask;
    
    [self.buttonContainerView fadeOutWithCompletion:^{
        self.notificationContentLabel.autoresizingMask = notificationContentLabelResizing;
        self.timeLabel.autoresizingMask = timeLabelResizing;
    }];
    
    [self.delegate cellHeightDidChange];
}

- (IBAction)didClickIgnoreButton:(UIButton *)sender {
    
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
        
        [self resetHeight:[WTNotificationFriendInvitationCell cellHeightWithNotificationObject:friendInvitation]];
    }
}

@end
