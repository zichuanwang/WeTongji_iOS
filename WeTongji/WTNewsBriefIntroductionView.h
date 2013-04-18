//
//  WTNewsBriefIntroductionView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class News;

@interface WTNewsBriefIntroductionView : UIView

@property (nonatomic, weak) IBOutlet UILabel *publisherLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *publishTimeLabel;

+ (WTNewsBriefIntroductionView *)createNewsBriefIntroductionViewWithNews:(News *)news;

@end

@interface WTOfficialNewsBriefIntroductionView : WTNewsBriefIntroductionView

@end
