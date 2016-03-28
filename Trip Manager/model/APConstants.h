// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
//
//  Copyright © 2016 Andi Palo
//  This file is part of project: TripManager
//
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

#undef TEST_MODE
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
