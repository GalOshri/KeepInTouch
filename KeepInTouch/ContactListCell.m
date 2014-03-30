//
//  ContactListCell.m
//  KitSample
//
//  Created by Gal Oshri on 1/1/14.
//  Copyright (c) 2014 BT601. All rights reserved.
//

#import "ContactListCell.h"

@implementation ContactListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    //[self setAccessoryType:UITableViewCellAccessoryNone];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
