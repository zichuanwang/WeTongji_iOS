//
//  WTSoundManager.h
//  VCard
//
//  Created by 王 紫川 on 12-7-23.
//  Copyright (c) 2012年 Mondev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTSoundManager : NSObject

+ (id)sharedManager;

- (void)loadSoundResource;

- (void)playPianoTone:(NSInteger)key;

@end
