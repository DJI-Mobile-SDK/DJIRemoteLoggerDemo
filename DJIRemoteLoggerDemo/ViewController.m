//
//  ViewController.m
//  DJIRemoteLoggerDemo
//
//  Created by DJI on 2/12/15.
//  Copyright © 2015 DJI. All rights reserved.
//

#import "ViewController.h"
#import <DJISDK/DJISDK.h>

#define ENTER_DEBUG_MODE 1

@interface ViewController ()<DJISDKManagerDelegate>
- (IBAction)logSDKVersionButtonAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerApp];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerApp
{
    //Please enter the App Key in the info.plist file.
    [DJISDKManager registerAppWithDelegate:self];
}

- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - DJISDKManager Delegate Method
- (void)appRegisteredWithError:(NSError *)error{

    NSString* message = @"Register App Successed!";
    if (error) {
        message = @"Register App Failed! Please enter your App Key and check the network.";
    }else
    {
        [DJISDKManager enableRemoteLoggingWithDeviceID:@"Enter Device ID Here" logServerURLString:@"Enter URL Here"];
    }
    
    [self showAlertViewWithTitle:@"Register App" withMessage:message];
}

- (void)productConnected:(DJIBaseProduct *)product
{
    
    //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
    [[DJISDKManager userAccountManager] logIntoDJIUserAccountWithAuthorizationRequired:NO withCompletion:^(DJIUserAccountState state, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Login failed: %@", error.description);
        }
    }];
}

#pragma mark - IBAction Method

- (IBAction)logSDKVersionButtonAction:(id)sender {
    
    DJILogDebug(@"SDK Version: %@", [DJISDKManager SDKVersion]);
}

@end
