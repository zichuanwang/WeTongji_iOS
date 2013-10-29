//
//  WTRouteImageView.m
//  WeTongji
//
//  Created by Tom Hu on 13-10-29.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTRouteImageView.h"

@interface WTRouteImageView ()

@property (nonatomic, weak) NSDictionary *routeInfo;

@end

@implementation WTRouteImageView

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

#pragma mark - UI methods

- (void)configureView {
    [self configureScrollView];
    [self configureRouteImageInRouteScrollView:self.firstRouteScrollView index:1];
    [self configureRouteImageInRouteScrollView:self.secondRouteScrollView index:2];
}

- (void)configureScrollView {
    [self.firstRouteScrollView setFrame:CGRectMake(0, 0, 320, 100)];
    [self.secondRouteScrollView setFrame:CGRectMake(0, 100, 320, 100)];
}

//Add Image
- (void)configureRouteImageInRouteScrollView:(UIScrollView *)routeScrollView index:(NSInteger)index {
    //Load Image
    NSString *routeImageNamge = @"guide_";
    routeImageNamge = [[[routeImageNamge stringByAppendingString:[self.routeInfo objectForKey:@"id"]]
                        stringByAppendingString:@"_"]
                       stringByAppendingString:[NSString stringWithFormat:@"%d", index]];
    UIImage *routeImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:routeImageNamge ofType:@"png"]];
    UIImageView *routeImageView = [[UIImageView alloc] initWithImage:routeImage];
    
    //Scale Image
    float ratio = 1.0f;
    CGRect routeImageFrame = routeImageView.frame;
    ratio = routeScrollView.frame.size.height / routeImageFrame.size.height;
    routeImageFrame.size.height *= ratio;
    routeImageFrame.size.width *= ratio;
    [routeImageView setFrame:routeImageFrame];
    [routeScrollView setContentSize:routeImageFrame.size];
    
    //Add to ScrollView
    [routeScrollView addSubview:routeImageView];
}

#pragma mark - Factory methods

+ (WTRouteImageView *)createRouteImageViewWithImageNamge:(NSDictionary *)routeInfo {
    WTRouteImageView *result = [[NSBundle mainBundle] loadNibNamed:@"WTRouteImageView" owner:nil options:nil].lastObject;
    result.routeInfo = routeInfo;
    [result configureView];
    return result;
}

@end
