//
//  WTConfigLoader.h
//  WeTongji
//
//  Created by 王 紫川 on 13-2-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTableViewType                  @"TableViewType"
#define kTableViewContent               @"TableViewContent"

#define kCellTitle                      @"CellTitle"
#define kCellThumbnail                  @"CellThumbnail"
#define kCellAccessoryType              @"CellAccessoryType"

#define kCellAccessoryTypeNone          @"CellAccessoryTypeNone"
#define kCellAccessoryTypeSwitch        @"CellAccessoryTypeSwitch"
#define kCellAccessoryTypeDisclosure    @"CellAccessoryTypeDisclosure"
#define kCellAccessoryTypeCheckmark     @"CellAccessoryTypeCheckmark"

#define kTableViewTypePlain             @"TableViewTypePlain"
#define kTableViewTypeGroup             @"TableViewTypeGroup"
#define kTableViewTypeSeparator         @"TableViewTypeSeparator"

#define kTableViewSectionHeader         @"TableViewSectionHeader"

#define kWTActivityConfig               @"WTActivitySettingConfig"
#define kWTNewsConfig                   @"WTNewsSettingConfig"

@interface WTConfigLoader : NSObject {
    NSMutableDictionary *_configDictionary;
}

+ (WTConfigLoader *)sharedLoader;

- (NSArray *)loadConfig:(NSString *)configKey;

@end
