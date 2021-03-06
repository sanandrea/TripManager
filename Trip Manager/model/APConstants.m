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
//  APConstants.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "APConstants.h"
#import "Customer.h"
#import "RoleMapping.h"

NSString *const kSecurityTokenKey = @"integrated-services-token";
NSString *const kSecurityUserNameKey = @"integrated-services-user";
NSString *const kKeyChainServiceURL = @"tripmanager.andipalo.com";
NSString *const kLastUserRole = @"last-user-role";

static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
static int randomLength = 6;

@interface APConstants()
@property (strong, nonatomic) LBRESTAdapter *adapter;
@property (strong, nonatomic) CustomerRepository* repository;
@end

@implementation APConstants

+ (id) sharedInstance{
    static APConstants *_sharedInstance = nil;

    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APConstants alloc] init];
    });
    return _sharedInstance;
}

- (id) init{
    if (self = [super init]) {
        self.adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://127.0.0.1:3000/api/v1"]];
        self.repository = (CustomerRepository*) [self.adapter repositoryWithClass:[CustomerRepository class]];
        self.currentUserRole = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastUserRole] intValue];
    }
    return self;
}

- (LBRESTAdapter*) getCurrentAdapter{
    return self.adapter;
}
- (LBPersistedModelRepository*) getCustomerRepository{
    return self.repository;
}
- (LBUser*) getLoggedInUser{
    return self.repository.cachedCurrentUser;
}

- (void) updateRoleWithUser:(LBUser*)user on:(APSuccessBlock)success when:(SLFailureBlock)failure{
    if (![user valueForKey:@"id"]) {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"User is not logged in", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"call this with logged in user", nil)
                                   };
        NSError *error = [NSError errorWithDomain:@"APDomain"
                                             code:-57
                                         userInfo:userInfo];
        failure(error);
    }
    LBRESTAdapter* adapter = [[APConstants sharedInstance] getCurrentAdapter];
    RoleMappingRepository *repo = (RoleMappingRepository*)[adapter repositoryWithClass:[RoleMappingRepository class]];
    
    NSDictionary *filter = @{@"include":@"role",@"where":@{@"principalId":[user valueForKey:@"id"]}};
    [repo findWithFilter:filter success:^(NSArray *roleMappings){
        if ([roleMappings count] == 0) {
            self.currentUserRole = kUserRoleDefault;
        }else{
            RoleMapping *rm = [roleMappings objectAtIndex:0];
            if ([rm[@"role"][@"name"] isEqualToString:@"admin"]) {
                self.currentUserRole = kUserRoleAdmin;
            }else if ([rm[@"role"][@"name"] isEqualToString:@"manager"]) {
                self.currentUserRole = kUserRoleManager;
            }
        }
        [[NSUserDefaults standardUserDefaults] setValue:@(self.currentUserRole)
                                                 forKey:kLastUserRole];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        success();
    }failure:failure];
}

+(NSString*) randomUsername{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: randomLength];
    
    for (int i=0; i<randomLength; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

@end
