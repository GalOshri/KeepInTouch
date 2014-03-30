//
//  ViewController.m
//  KitSample
//
//  Created by Gal Oshri on 12/29/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import "ViewController.h"
#import "ContactListView.h"
#import "Contact.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "ContactCell.h"

@interface ViewController ()

@property (strong, nonatomic) ContactList *contactList;
@property (strong, nonatomic) NSMutableArray *currentMission;

@end

@implementation ViewController

NSInteger numMissionContacts = 3;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Contact List"]) {
        if ([segue.destinationViewController isKindOfClass:[ContactListView class]]) {
            ContactListView *clv = (ContactListView *)segue.destinationViewController;
            clv.contactList = self.contactList;
        }
    }
}

- (ContactList *)contactList
{
    if (!_contactList)
    {
        _contactList = [[ContactList alloc] init];
    }
    
    return _contactList;
}

- (NSMutableArray *)currentMission
{
    if (!_currentMission)
    {
        _currentMission = [[NSMutableArray alloc] init];
    }
    return _currentMission;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.contactList populateContacts];
    
    // Populate current mission
    if (numMissionContacts > [self.contactList.contacts count])
        numMissionContacts = [self.contactList.contacts count];
    
    for (int i = 0; i < numMissionContacts; i++)
    {
        Contact *contact = [self.contactList.contacts objectAtIndex:(arc4random() % [self.contactList.contacts count])];
        while ([self.currentMission containsObject:contact])
        {
            contact = [self.contactList.contacts objectAtIndex:(arc4random() % [self.contactList.contacts count])];
        }
        [self.currentMission addObject:contact];
    }
    
    // table stuff
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // Set up contact list array
    
    [self.tableView reloadData];
    
}

#pragma mark - Actions From Cell

- (void)contactSoftDismissed:(Contact *)contact
{
    NSUInteger index = [self.contactList.contacts indexOfObject:contact];
    [self.tableView beginUpdates];
    [self.contactList.contacts removeObject:contact];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self.contactList saveContacts];
}

- (void)contactHardDismissed:(Contact *)contact
{
    return;
}

- (void)contactRecentTouch:(Contact *)contract
{
    return;
}

- (void)contactSendEmail:(Contact *)contact
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSArray *toRecipents = [NSArray arrayWithObject:[contact getContactEmail]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device cannot send Email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];

}

- (void)contactSendMessage:(Contact *)contact
{
    if ([MFMessageComposeViewController canSendText])
    {
        NSArray *recipents = @[[contact getContactPhoneNumber]];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device cannot send texts"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table Protocol Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentMission count];
}

- (ContactCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = @"cell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    int index = [indexPath row];
    Contact *contact = [self.currentMission objectAtIndex:index];
    
    cell.textLabel.text = contact.firstName;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    cell.delegate = self;
    cell.contact = contact;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell toggleMenu];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell hideMenu];
}

#pragma mark - Table Delegate Methods

- (UIColor *)colorForIndex:(NSInteger) index
{
    NSUInteger itemCount = [self.currentMission count] - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed:1.0 green:val blue:0.0 alpha:1.0];
}

#pragma mark - UITableViewDataDelegate protocol methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

@end
