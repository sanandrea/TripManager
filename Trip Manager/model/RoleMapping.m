//
//  RoleMapping.m
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "RoleMapping.h"

@implementation RoleMapping

@end

@implementation RoleMappingRepository
+ (instancetype)repository {
    return [self repositoryWithClassName:@"rolemappings"];
}
@end