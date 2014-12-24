//
//  SFHMemoryAlert.m
//  DemoApp
//
//  Created by 古林 俊祐 on 2014/12/14.
//  Copyright (c) 2014年 ShunsukeFurubayashi. All rights reserved.
//

/**
 *　TODO:
 *   ・localize
 *   ・Use bundle image
 */

#import "SFHMemoryAlert.h"

#import "SFHNoticeLabelView.h"
#import "UIDevice+SFHDevice.h"

NSString * const SFHMemoryAlertWillDisappearNotification    = @"SFHMemoryAlertWillDisappearNotification";
NSString * const SFHMemoryAlertDidDisappearNotification     = @"SFHMemoryAlertDidDisappearNotification";
NSString * const SFHMemoryAlertWillAppearNotification       = @"SFHMemoryAlertWillAppearNotification";
NSString * const SFHMemoryAlertDidAppearNotification        = @"SFHMemoryAlertDidAppearNotification";

@interface SFHMemoryAlert ()

@property (readwrite, nonatomic) SFHMemoryAlertMaskType maskType;
@property (readwrite, nonatomic) BOOL autoShowAlert;
@property (readwrite, nonatomic) NSUInteger afterShowingCount;
@property (readwrite, nonatomic) NSUInteger warningCount;
@property (nonatomic, strong) UIControl *overlayView;
@property (strong, nonatomic) UIView *alertView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UIImageView *bottomImageView;
@property (strong, nonatomic) SFHNoticeLabelView *topNoticeLabelView;
@property (strong, nonatomic) SFHNoticeLabelView *bottomNoticeLabelView;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation SFHMemoryAlert

#pragma mark - Receive Memory Warning
- (void)didReceiveMemoryWarning {
    if (self.autoShowAlert) {
        if (self.warningCount == 0) {
            [self showWithMaskType:self.maskType];
            self.warningCount ++;
        } else {
             if (self.afterShowingCount < self.warningCount) {
                [self showWithMaskType:self.maskType];
                self.warningCount = 1;
            } else {
                self.warningCount ++;
            }
        }
    }
}

#pragma mark - Class Methods
+ (void)setup {
    [SFHMemoryAlert sharedView];
}

+ (void)setAutoShowAlert:(BOOL)autoShowAlert {
    [self sharedView].autoShowAlert = autoShowAlert;
}

+ (void)setMaskType:(SFHMemoryAlertMaskType)maskType {
    [self sharedView].maskType = maskType;
}

+ (void)setCountAfterShowing:(NSUInteger)value {
    [self sharedView].afterShowingCount = value;
}

+ (void)show {
    [[self sharedView] showWithMaskType:SFHMemoryAlertMaskTypeBlack];
}

+ (void)showWithMaskType:(SFHMemoryAlertMaskType)maskType {
    [[self sharedView] showWithMaskType:maskType];
}

+ (void)dismiss {
    if ([self isVisible]) {
        [[self sharedView] dismiss];
    }
}

+ (BOOL)isVisible {
    return ([self sharedView].alpha == 1);
}

#pragma mark - Private Methods
- (void)showWithMaskType:(SFHMemoryAlertMaskType)maskType {
    
    if (!self.overlayView.superview) {
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
    
    self.maskType = maskType;
    
    [self updatePosition];
    
    self.overlayView.hidden = NO;
    self.overlayView.backgroundColor = [UIColor clearColor];
    
    if(self.alpha != 1 || self.alertView.alpha != 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SFHMemoryAlertWillAppearNotification object:nil userInfo:nil];
        
        [self registerNotifications];
    
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             [[NSNotificationCenter defaultCenter] postNotificationName:SFHMemoryAlertDidAppearNotification object:nil userInfo:nil];
                         }];
        
        [self setNeedsDisplay];
    }
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] postNotificationName:SFHMemoryAlertWillDisappearNotification object:nil userInfo:nil];

    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         if(self.alpha == 0.0f || self.alertView.alpha == 0.0f) {
                             self.alpha = 0.0f;
                             self.alertView.alpha = 0.0f;
                             
                             [self removeViews];
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:SFHMemoryAlertDidDisappearNotification object:nil userInfo:nil];

                             UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
                             if ([rootController respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                                 [rootController setNeedsStatusBarAppearanceUpdate];
                             }
                         }
                     }];
}

- (void)updatePosition {

    self.frame = [[UIScreen mainScreen] bounds];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    if (isLandscape) {
        
        self.alertView.frame = CGRectMake(0, 0, ([UIDevice is3_5inch]) ? 460 : 538, 270);
        self.alertView.center = self.center;
        
        self.titleLabel.frame = CGRectMake(0, 26, CGRectGetWidth(self.alertView.frame), 25);
        
        
        self.topImageView.image = [UIImage imageNamed:@"landscape_image1"];
        self.topImageView.frame = CGRectMake((CGRectGetMidX(self.alertView.bounds) - 153) / 2, 81, 153, 76);
        
        self.bottomImageView.image = [UIImage imageNamed:@"landscape_image2"];
        self.bottomImageView.frame = CGRectMake(CGRectGetMidX(self.alertView.bounds) + ((CGRectGetMidX(self.alertView.bounds) - 193) / 2), 81, 193, 76);
        
        self.topNoticeLabelView.frame = CGRectMake(0, 174, CGRectGetMidX(self.alertView.bounds), 16);
        
        self.bottomNoticeLabelView.frame = CGRectMake(CGRectGetMidX(self.alertView.bounds), 174, CGRectGetMidX(self.alertView.bounds), 16);
        
        self.closeButton.frame = CGRectMake(15, 215, CGRectGetWidth(self.alertView.frame) - 30, 39);
        
    } else {
        
        self.alertView.frame = CGRectMake(0, 0, 290, ([UIDevice is3_5inch]) ? 440 : 518);
        self.alertView.center = self.center;
        
        self.titleLabel.frame = CGRectMake(0, ([UIDevice is3_5inch]) ? 12 : 24, CGRectGetWidth(self.alertView.frame), 25);
        
        self.topImageView.image = [UIImage imageNamed:@"portrait_image1"];
        self.topImageView.frame = CGRectMake(60, ([UIDevice is3_5inch]) ? 50 : 75, 170, 125);
        
        self.bottomImageView.image = [UIImage imageNamed:@"portrait_image2"];
        self.bottomImageView.frame = CGRectMake(65, ([UIDevice is3_5inch]) ? 215 : 270, 159, 125);
        
        self.topNoticeLabelView.frame = CGRectMake(0, ([UIDevice is3_5inch]) ? 185 : 220, CGRectGetWidth(self.alertView.frame), 16);
        
        self.bottomNoticeLabelView.frame = CGRectMake(0, ([UIDevice is3_5inch]) ? 355 : 415, CGRectGetWidth(self.alertView.frame), 16);
        
        self.closeButton.frame = CGRectMake(15, ([UIDevice is3_5inch]) ? 385 : 460, CGRectGetWidth(self.alertView.frame) - 30, 43);
        
    }
    

    [self.closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    self.titleLabel.text = @"メモリが不足しています";
    [self.topNoticeLabelView setTitle:@"ホームボタンをダブルクリックします。" number:1];
    [self.bottomNoticeLabelView setTitle:@"他のアプリを上にスワイプしてください。" number:2];
    
}

- (void)registerNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePosition)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.maskType == SFHMemoryAlertMaskTypeBlack) {
        [[UIColor colorWithWhite:0 alpha:0.5] set];
        CGContextFillRect(context, self.bounds);
    }
}

#pragma mark - Init
+ (SFHMemoryAlert *)sharedView {
    static SFHMemoryAlert *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.0f;
        self.afterShowingCount = 0;
        self.warningCount = 0;
        self.autoShowAlert = YES;
        self.maskType = SFHMemoryAlertMaskTypeBlack;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeViews {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self.titleLabel removeFromSuperview];
    self.titleLabel = nil;
    [self.topImageView removeFromSuperview];
    self.topImageView = nil;
    [self.bottomImageView removeFromSuperview];
    self.bottomImageView = nil;
    [self.topNoticeLabelView removeFromSuperview];
    self.topNoticeLabelView = nil;
    [self.bottomNoticeLabelView removeFromSuperview];
    self.bottomNoticeLabelView = nil;
    [self.closeButton removeFromSuperview];
    self.closeButton = nil;
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}

#pragma mark - Getters
- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 7;
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.5] CGColor];
        _alertView.layer.borderWidth = 1;
        _alertView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
    }
    if (!_alertView.superview) {
        [self addSubview:_alertView];
    }
    return _alertView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"HirakakuProN-W3" size:22];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (!_titleLabel.superview) {
        [self.alertView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [UIImageView new];
    }
    if (!_topImageView.superview) {
        [self.alertView addSubview:_topImageView];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [UIImageView new];
    }
    if (!_bottomImageView.superview) {
        [self.alertView addSubview:_bottomImageView];
    }
    return _bottomImageView;
}

- (SFHNoticeLabelView *)topNoticeLabelView {
    if (!_topNoticeLabelView) {
        _topNoticeLabelView = [SFHNoticeLabelView new];
    }
    if (!_topNoticeLabelView.superview) {
        [self.alertView addSubview:_topNoticeLabelView];
    }
    return _topNoticeLabelView;
}

- (SFHNoticeLabelView *)bottomNoticeLabelView {
    if (!_bottomNoticeLabelView) {
        _bottomNoticeLabelView = [SFHNoticeLabelView new];
    }
    if (!_bottomNoticeLabelView.superview) {
        [self.alertView addSubview:_bottomNoticeLabelView];
    }
    return _bottomNoticeLabelView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        _closeButton.backgroundColor = [UIColor colorWithRed:0.784314f green:0.784314f blue:0.784314f alpha:1];
        _closeButton.layer.cornerRadius = 2;
        _closeButton.layer.masksToBounds = YES;
        _closeButton.titleLabel.font = [UIFont fontWithName:@"HirakakuProN-W3" size:15];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!_closeButton.superview) {
        [self.alertView addSubview:_closeButton];
    }
    return _closeButton;
}

@end
