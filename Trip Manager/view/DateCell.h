//
//  DateCell.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataProvider.h"

@interface DateCell : UITableViewCell<CellDataProvider>
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateValue;

@property (strong, nonatomic) NSDate *date;

@property (nonatomic) BOOL isStartDate;
@end
