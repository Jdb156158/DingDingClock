//
//  AppDelegate.m
//  DingDingClock
//
//  Created by db J on 2021/2/23.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SleepDetailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[[SleepDetailViewController alloc]init]];
    [self.window makeKeyAndVisible];

    return YES;
}


@end
