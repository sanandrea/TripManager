//
//  APConstants.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "APConstants.h"

NSString *const kSecurityTokenKey = @"integrated-services-token";
NSString *const kSecurityUserNameKey = @"integrated-services-user";
NSString *const kKeyChainServiceURL = @"tripmanager.andipalo.com";

@interface APConstants()
@property (strong, nonatomic) LBRESTAdapter *adapter;
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
    }
    return self;
}

- (LBRESTAdapter*) getCurrentAdapter{
    return self.adapter;
}

@end
