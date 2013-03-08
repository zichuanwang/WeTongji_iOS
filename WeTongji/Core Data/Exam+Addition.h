//
//  Exam+Addition.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Exam.h"
@interface Exam (Addition)

+ (Exam *)insertExam:(NSDictionary *)dic;

+ (Exam *)examWithNo:(NSString *)examNO;

@end
