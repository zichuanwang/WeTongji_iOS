//
//  WTYellowPageCell.h
//  WeTongji
//
//  Created by Tom Hu on 13-10-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTHighlightableCell.h"

@interface WTYellowPageCell : WTHighlightableCell

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *officeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                        OfficeName:(NSString *)officeName
                       PhoneNumber:(NSString *)phoneNumber;

@end
