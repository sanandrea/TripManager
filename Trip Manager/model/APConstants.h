//
//  APConstants.h
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define CALLBACK_FAILURE_BLOCK \
    ^(NSError *error) { \
    ALog("Callback failed: %@", error.description); \
    }

extern NSString *const kSecurityTokenKey;
extern NSString *const kSecurityUserNameKey;
extern NSString *const kKeyChainServiceURL;

@interface APConstants : NSObject

+ (id) sharedInstance;
- (LBRESTAdapter*) getCurrentAdapter;

+(NSString*) randomUsername;

@end
