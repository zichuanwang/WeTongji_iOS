//
//  WTSoundManager.m
//  VCard
//
//  Created by 王 紫川 on 12-7-23.
//  Copyright (c) 2012年 Mondev. All rights reserved.
//

#import "WTSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

static WTSoundManager *WTSoundManagerInstance = nil;

@interface WTSoundManager()

@property (nonatomic, strong) NSMutableArray *pianoToneSoundIDArray;

@end

@implementation WTSoundManager

+ (id)sharedManager {
    if(!WTSoundManagerInstance) {
        WTSoundManagerInstance = [[WTSoundManager alloc] init];
    }
    //    if([NSUserDefaults isSoundEffectEnabled])
    //        return WTSoundManagerInstance;
    //    else
    //        return nil;
    return WTSoundManagerInstance;
}

//- (id)init {
//    self = [super init];
//    if(self) {
//        [self loadSoundResource];
//    }
//    return self;
//}

- (NSMutableArray *)pianoToneSoundIDArray {
    if(_pianoToneSoundIDArray == nil) {
        _pianoToneSoundIDArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _pianoToneSoundIDArray;
}

- (void)loadSoundResource {
    for(int i = 1; i <= 5; i++) {
        NSString* pianoTonePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"dtmf%d", i] ofType:@"wav"];
        if (pianoTonePath) {
            NSURL* newMessageSoundUrl = [NSURL fileURLWithPath:pianoTonePath];
            SystemSoundID soundID;
            OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)newMessageSoundUrl, &soundID);
            if (err != kAudioServicesNoError) {
                NSLog(@"WTSoundManager : Could not load %@, error code %d", newMessageSoundUrl ,(int)err);
            }
            [self.pianoToneSoundIDArray addObject:[NSNumber numberWithUnsignedLong:soundID]];
        }
    }
}

- (void)playPianoTone:(NSInteger)key {
    NSNumber *soundIDNumber = self.pianoToneSoundIDArray[key - 1];
    SystemSoundID soundID = soundIDNumber.unsignedLongValue;
    AudioServicesPlaySystemSound(soundID);
}

@end
