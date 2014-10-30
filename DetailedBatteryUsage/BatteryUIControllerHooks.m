//
//  BatteryUIControllerHooks.m
//  DetailedBatteryUsage
//
//  Created by Hamza Sood on 30/10/2014.
//  Copyright (c) 2014 Hamza Sood. All rights reserved.
//

@import Foundation;
@import ObjectiveC.runtime;




static int BatteryUIType() {
    return 2; /* 0 = normal, 1 = without daemons or demo options, 2 = complete */
}




char *bundleLoadedObserver = "Hello :)";

void BatteryUsageUIBundleLoadedNotificationFired(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if (objc_getClass("BatteryUIController") == Nil)
        return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_setImplementation(class_getInstanceMethod(objc_getClass("BatteryUIController"), @selector(batteryUIType)),
                                 (IMP)BatteryUIType);
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetLocalCenter(),
                                           bundleLoadedObserver,
                                           (CFStringRef)NSBundleDidLoadNotification,
                                           NULL);
    });
}

__attribute__((constructor)) static void BatteryUIControllerHooksInit() {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),
                                    bundleLoadedObserver,
                                    BatteryUsageUIBundleLoadedNotificationFired,
                                    (CFStringRef)NSBundleDidLoadNotification,
                                    [NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/BatteryUsageUI.bundle"],
                                    CFNotificationSuspensionBehaviorCoalesce);
}