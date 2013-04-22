//
//  WTLoginIntroViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTLoginIntroViewController.h"

@interface WTLoginIntroViewController ()

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WTRootBgUnit"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetFrame:(CGRect)frame {
    self.view.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 5, self.scrollView.frame.size.height);
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
    for (int i = 0; i < 5; i++) {
        int index = i;
        if (index == 0)
            index = 3;
        else if (index == 4)
            index = 1;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"WTLoginIntroImage%d.jpg", index]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingNone;
        [imageView resetSize:CGSizeMake(image.size.width / 2, image.size.height / 2)];
        
        [imageView resetOriginX:i * self.scrollView.frame.size.width];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    self.pageControl.numberOfPages = 3;
}

- (void)updateScrollView {
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    if (currentPage == self.pageControl.numberOfPages + 1) {
        currentPage = 0;
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    } else if (currentPage == 0) {
        currentPage = 2;
        self.scrollView.contentOffset = CGPointMake(self.pageControl.numberOfPages * self.scrollView.frame.size.width, 0);
    } else {
        currentPage--;
    }
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
