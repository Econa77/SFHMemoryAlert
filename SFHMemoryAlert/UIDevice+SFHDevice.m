//
//  UIDevice+SFHDevice.m
//  DemoApp
//
//  Created by 古林俊佑 on 2014/12/25.
//  Copyright (c) 2014年 ShunsukeFurubayashi. All rights reserved.
//

#import "UIDevice+SFHDevice.h"

@implementation UIDevice (SFHDevice)

+ (BOOL)is3_5inch {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    if (isLandscape) {
        return (screenSize.width == 480.0f && screenSize.height == 320.0f);
    } else {
       return (screenSize.width == 320.f && screenSize.height == 480.0f);
    }
}

@end
