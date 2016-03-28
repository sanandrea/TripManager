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
//  Customer.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "Customer.h"
#import "RoleMapping.h"

@implementation Customer

@end

@interface CustomerRepository()
@property (nonatomic, readwrite) Customer *cachedCurrentCustomer;

@end

@implementation CustomerRepository
+ (instancetype)repository {
    return [self repositoryWithClassName:@"customers"];
}
- (SLRESTContract *)contract {
    SLRESTContract *contract = [super contract];
    
    [contract addItem:[SLRESTContractItem itemWithPattern:[NSString stringWithFormat:@"/%@/:id/trips", self.className] verb:@"GET"]
            forMethod:[NSString stringWithFormat:@"%@.trip-list", self.className]];
    
    
    [contract addItem:[SLRESTContractItem itemWithPattern:[NSString stringWithFormat:@"/%@/:id/promote", self.className] verb:@"POST"]
            forMethod:[NSString stringWithFormat:@"%@.promote-user", self.className]];
    
    
    return contract;
}

@end