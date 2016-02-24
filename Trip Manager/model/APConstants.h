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


typedef enum UserRole {
    kUserRoleDefault,
    kUserRoleManager,
    kUserRoleAdmin
} UserRole;

typedef void (^APSuccessBlock)();

@protocol LogoutHandlerProtocol <NSObject>

- (void) logoutUser;

@end

extern NSString *const kSecurityTokenKey;
extern NSString *const kSecurityUserNameKey;
extern NSString *const kKeyChainServiceURL;

extern NSString *const kLastUserRole;

@interface APConstants : NSObject
@property (nonatomic) UserRole currentUserRole;

+ (id) sharedInstance;
- (LBRESTAdapter*) getCurrentAdapter;
- (LBPersistedModelRepository*) getCustomerRepository;
- (LBUser*) getLoggedInUser;
- (void) updateRoleWithUser:(LBUser*)user on:(APSuccessBlock)success when:(SLFailureBlock)failure;


+(NSString*) randomUsername;

@end
