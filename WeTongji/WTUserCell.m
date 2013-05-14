//
//  WTUserCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUserCell.h"

@implementation WTUserCell

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              user:(User *)user {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
}

@end
