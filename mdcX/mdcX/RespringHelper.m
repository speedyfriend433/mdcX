//
//  RespringHelper.m
//  mdcX
//
//  Created by 이지안 on 5/12/25.
//

#import "RespringHelper.h"
#import <CoreFoundation/CoreFoundation.h>
// extern void CFNotificationCenterPostNotification(CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately);


@implementation RespringHelper

+ (void)attemptDarwinRespring {
    NSLog(@"[RespringHelper] Attempting to post com.apple.springboard.respring to Darwin Notify Center");
    
    CFNotificationCenterRef darwinNotifyCenter = CFNotificationCenterGetDarwinNotifyCenter();
    if (darwinNotifyCenter) {
        CFStringRef notificationName = CFSTR("com.apple.springboard.respring");
        
        CFNotificationCenterPostNotification(darwinNotifyCenter,
                                             notificationName,
                                             NULL, 
                                             NULL,
                                             TRUE);
        
        NSLog(@"[RespringHelper] Notification 'com.apple.springboard.respring' posted.");
    } else {
        NSLog(@"[RespringHelper] Failed to get Darwin Notify Center.");
    }
}

@end
