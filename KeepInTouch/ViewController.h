//
//  ViewController.h
//  KitSample
//
//  Created by Gal Oshri on 12/29/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCellDelegate.h"
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ContactCellDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
