//
//  WTYellowPageCell.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTYellowPageCell.h"

@implementation WTYellowPageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                        OfficeName:(NSString *)officeName
                       PhoneNumber:(NSString *)phoneNumber {
    [super configureCellWithIndexPath:indexPath];
    
    self.officeNameLabel.text = officeName;
    self.phoneNumberLabel.text = phoneNumber;
}

- (IBAction)callNumber:(UIButton *)sender {
    NSString *number = [[NSString alloc] initWithFormat:@"telprompt://%@", self.phoneNumberLabel.text];
    
    //Call
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}


@end
