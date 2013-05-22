//
//  WTLoginIntroViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLoginIntroViewController.h"

@interface WTLoginIntroViewController ()

@property (nonatomic, assign) NSInteger currentIntroBgImageIndex;

@end

@implementation WTLoginIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configureScrollView];
    [self configureLocalizationLabels];
    
    [self introBgImageViewLoopAnimation];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetFrame:(CGRect)frame {
    self.view.frame = frame;
    WTLOG(@"%@, %@", NSStringFromCGRect(frame), NSStringFromCGRect(self.introBgImageViewA.frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
}

#pragma mark - Animations

- (void)introBgImageViewLoopAnimation {
    
    self.introBgImageViewB.image = self.introBgImageViewA.image;
    self.introBgImageViewB.alpha = 1.0f;
    
    self.currentIntroBgImageIndex++;
    if (self.currentIntroBgImageIndex > 2) {
        self.currentIntroBgImageIndex = 0;
    }
    
    self.introBgImageViewA.image = [UIImage imageNamed:[NSString stringWithFormat:@"WTLoginIntroImage%d.jpg", self.currentIntroBgImageIndex + 1]];
    
    [UIView animateWithDuration:1.0f delay:3.0f options:UIViewAnimationCurveEaseInOut animations:^{
        
        self.introBgImageViewB.alpha = 0;

    } completion:^(BOOL finished) {
        [self introBgImageViewLoopAnimation];
    }];
}

#pragma mark - UI methods

- (void)configureLocalizationLabels {
    self.campusInYourPocketLabel.text = NSLocalizedString(self.campusInYourPocketLabel.text, nil);
    [self.tourButton setTitle:NSLocalizedString(@"Tour", nil) forState:UIControlStateNormal];
    
    CGFloat tourButtonHeight = self.tourButton.frame.size.height;
    CGFloat tourButtonCenterY = self.tourButton.center.y;
    CGFloat tourButtonRightBoundX = self.tourButton.frame.origin.x + self.tourButton.frame.size
    .width;
    [self.tourButton sizeToFit];
    
    [self.tourButton resetHeight:tourButtonHeight];
    [self.tourButton resetCenterY:tourButtonCenterY];
    [self.tourButton resetOriginX:tourButtonRightBoundX - self.tourButton.frame.size.width];

}

- (void)configureScrollView {
    self.pageControl.numberOfPages = 3;
}

- (void)updateScrollView {
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

#pragma mark - Actions

- (IBAction)didClickTourButton:(UIButton *)sender {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    scrollView.userInteractionEnabled = YES;
    [self updateScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self updateScrollView];
    else
        scrollView.userInteractionEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
