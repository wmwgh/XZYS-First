//
//  AppDelegate.m
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ClassifyViewController.h"
#import "HomeViewController.h"
#import "ShoppingCarViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "EMSDK.h"
#import "EaseUI.h"
#import <AFHTTPSessionManager.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD.h>

@interface AppDelegate ()

@end


@implementation AppDelegate
@synthesize isLogin = No;
@synthesize selectId;
@synthesize userIdTag;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // 第二步：创建UITabBarController对象
    self.mainTab = [[UITabBarController alloc] init];
    
    // 第三步：设置window的根视图控制器
    self.window.rootViewController = self.mainTab;
    UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    loginVC.navigationBarHidden = YES;
    
    // 控制器
    UINavigationController *homeNVC = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    // 设置图片
    homeNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tb_08"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tb_09"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *classNVC = [[UINavigationController alloc] initWithRootViewController:[[ClassifyViewController alloc] init]];
    // 设置图片
    classNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[[UIImage imageNamed:@"tb_05"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tb_03"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *shoppingNVC = [[UINavigationController alloc] initWithRootViewController:[[ShoppingCarViewController alloc] init]];
    // 设置图片
    shoppingNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:[[UIImage imageNamed:@"tb_06"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tb_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UINavigationController *userNVC = [[UINavigationController alloc] initWithRootViewController:[[UserViewController alloc] init]];
    // 设置图片
    userNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[[UIImage imageNamed:@"tb_07"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tb_02"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 将导航控制器对象添加到数组中
    self.mainTab.viewControllers = @[homeNVC,classNVC,shoppingNVC,userNVC];
    
    // 初始化EaseUI
    [[EaseSDKHelper shareHelper] easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"jiuguankeji#xzyskf" apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
#pragma mark - 自动登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    NSString *passWord = [defaults objectForKey:@"passWord"];
    if (userName != nil && passWord != nil && ![userName isEqualToString:@""] && ![passWord isEqualToString:@""]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *urlString = @"http://www.xiezhongyunshang.com/App/User/login";
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"username"] = userName;
        params[@"password"] = passWord;
        [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 数据加载完后回调.
            NSString *result = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
            NSDictionary *dataDic = responseObject[@"data"];
            if([result isEqualToString:@"-106"]){
                self.isLogin = @"Yes";
                self.userIdTag = dataDic[@"uid"];
#pragma mark -- 环信登录
                NSString *loginId = [NSString stringWithFormat:@"hx%@xzys", userName];
                NSString *loginWord = @"xzyspassword";
                EMError *error = [[EMClient sharedClient] loginWithUsername:loginId password:loginWord];
            } else {
                [self.mainTab presentViewController:loginVC animated:NO completion:nil];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:loginVC.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"登录失败，请重新登录";
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 数据加载失败回调.
        }];
    } else {
        [self.mainTab presentViewController:loginVC animated:NO completion:nil];
    }
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//             解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"%@", authCode);
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
            NSString *resultMsg = @"";
            if (resultStatus == 9000) {//交易成功
                resultMsg = @"交易成功";
            } else if (resultStatus == 8000) {
                resultMsg = @"订单正在处理中";
            } else if (resultStatus == 4000) {
                resultMsg = @"订单支付失败";
            } else if (resultStatus == 6001) {
                resultMsg = @"用户中途取消";
            } else if (resultStatus == 6002) {
                resultMsg = @"网络连接出错";
            } else {
                resultMsg = @"交易失败";
            }
            NSLog(@"-=-=-=-AppDelegate=-=-=-=-=%@", resultMsg);
            //发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notifPayFinish" object:self userInfo:[NSDictionary dictionaryWithObject:resultMsg forKey:@"sid"]];
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wmw.XZYS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XZYS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XZYS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
