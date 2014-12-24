//
//  SFHNoticeLabelView.m
//  DemoApp
//
//  Created by 古林俊佑 on 2014/12/24.
//  Copyright (c) 2014年 ShunsukeFurubayashi. All rights reserved.
//

#import "SFHNoticeLabelView.h"

@interface SFHNoticeLabelView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (readwrite, nonatomic) NSUInteger number;

@end

@implementation SFHNoticeLabelView

#pragma mark - Init
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    [self.titleLabel removeFromSuperview];
    self.titleLabel = nil;
}

#pragma mark - Self Methods
- (void)setTitle:(NSString *)title number:(NSUInteger)number {
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(((CGRectGetWidth(self.frame) - CGRectGetWidth(self.titleLabel.frame)) / 2) + 10, 3, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    
    self.number = number;
    [self setNeedsDisplay];
}

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float cx = CGRectGetMinX(self.titleLabel.frame) - 12;
    float cy = 8;
    float R = 8.0f;
    
    CGRect rectEllipse = CGRectMake(cx - R, cy - R, R*2, R*2);
    
    CGContextSetRGBFillColor(context, 0.557, 0.557, 0.557, 1);
    CGContextFillEllipseInRect(context, rectEllipse);
    
    [[NSString stringWithFormat:@"%lu",(unsigned long)self.number] drawAtPoint:CGPointMake(rectEllipse.origin.x + 4, rectEllipse.origin.y + 2) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                 [UIFont fontWithName:@"HirakakuProN-W6" size:11], NSFontAttributeName,
                                                                                                                 [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                                                                 nil]];
}

#pragma mark - Getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"HirakakuProN-W6" size:11];
        _titleLabel.textColor = [UIColor colorWithRed:0.553 green:0.553 blue:0.553 alpha:1];
    }
    if (!_titleLabel.superview) {
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


@end
