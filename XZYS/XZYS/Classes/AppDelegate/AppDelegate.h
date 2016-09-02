//
//  AppDelegate.h
//  XZYS
//
//  Created by 杨利 on 16/8/8.
//  Copyright © 2016年 吴明伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *isLogin;
    int selectId;
    NSString *userIdTag;
}
@property (copy,nonatomic) NSString *isLogin;
@property (nonatomic , copy) NSString *userIdTag;
@property (nonatomic , assign) int selectId;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic , strong) UITabBarController *mainTab;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

