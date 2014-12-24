//
//  SFHMemoryAlert.h
//  DemoApp
//
//  Created by 古林 俊祐 on 2014/12/14.
//  Copyright (c) 2014年 ShunsukeFurubayashi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const SFHMemoryAlertWillDisappearNotification;
extern NSString * const SFHMemoryAlertDidDisappearNotification;
extern NSString * const SFHMemoryAlertWillAppearNotification;
extern NSString * const SFHMemoryAlertDidAppearNotification;

typedef NS_ENUM (NSInteger, SFHMemoryAlertMaskType){
    SFHMemoryAlertMaskTypeNone,
    SFHMemoryAlertMaskTypeBlack,
};

@interface SFHMemoryAlert : UIView

+ (void)setup;
+ (void)setAutoShowAlert:(BOOL)autoShowAlert;
+ (void)setMaskType:(SFHMemoryAlertMaskType)maskType;
+ (void)setCountAfterShowing:(NSUInteger)value;

+ (void)show;
+ (void)showWithMaskType:(SFHMemoryAlertMaskType)maskType;
+ (void)dismiss;

+ (BOOL)isVisible;

@end
