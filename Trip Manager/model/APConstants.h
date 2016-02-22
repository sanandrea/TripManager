//
//  APConstants.h
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

extern NSString *const kSecurityTokenKey;
extern NSString *const kSecurityUserNameKey;
extern NSString *const kKeyChainServiceURL;

@interface APConstants : NSObject

+ (id) sharedInstance;
- (LBRESTAdapter*) getCurrentAdapter;

@end
