//
//  RoleMapping.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <LoopBack/LoopBack.h>

@interface RoleMapping : LBPersistedModel
@property (nonatomic,copy) NSString *principalType;
@property (nonatomic) NSNumber *principalId;
@property (nonatomic) NSNumber *roleId;
@end


@interface RoleMappingRepository : LBPersistedModelRepository
+ (instancetype)repository;
@end