//
//  ViewController.m
//  DemoApp
//
//  Created by 古林 俊祐 on 2014/12/14.
//  Copyright (c) 2014年 ShunsukeFurubayashi. All rights reserved.
//

#import "ViewController.h"

#import "SFHMemoryAlert.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryAlertWillAppear) name:SFHMemoryAlertWillAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryAlertDidAppear) name:SFHMemoryAlertDidAppearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryAlertWillDisappear) name:SFHMemoryAlertWillDisappearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryAlertDidDisappear) name:SFHMemoryAlertDidDisappearNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions
- (IBAction)showAlert:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(_performMemoryWarning)]) {
        [app performSelector:@selector(_performMemoryWarning)];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)memoryAlertWillAppear {
    NSLog(@"MemoryAlert will appear");
}

- (void)memoryAlertDidAppear {
    NSLog(@"MemoryAlert did appear");
}

- (void)memoryAlertWillDisappear {
    NSLog(@"MemoryAlert will disappear");
}

- (void)memoryAlertDidDisappear {
    NSLog(@"MemoryAlert did disappear");
}

@end
