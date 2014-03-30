//
//  ContactList.m
//  KitSample
//
//  Created by Gal Oshri on 12/29/13.
//  Copyright (c) 2013 BT601. All rights reserved.
//

#import "ContactListView.h"
#import "Contact.h"
#import "ContactView.h"
#import "ContactListCell.h"

@interface ContactListView ()

@end

@implementation ContactListView



#pragma mark - View Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Contact"]) {
        if ([segue.destinationViewController isKindOfClass:[ContactView class]] &&
            [sender isKindOfClass:[ContactListCell class]])
        {
            ContactView *cv = (ContactView *)segue.destinationViewController;
            ContactListCell *cell = (ContactListCell *)sender;
            cv.contact = cell.contact;
            cv.delegate = self;
        }
        else if ([segue.destinationViewController isKindOfClass:[ContactView class]] &&
                  [sender isKindOfClass:[Contact class]])
        {
            ContactView *cv = (ContactView *)segue.destinationViewController;
            Contact *contact = (Contact *)sender;
            cv.contact = contact;
            cv.editing = YES;
            cv.delegate = self;
        }

    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[ContactListCell class] forCellReuseIdentifier:@"Cell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Address Book Methods

- (IBAction)showPicker:(UIBarButtonItem *)sender {
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    
    [self presentViewController:picker animated:YES completion:nil];
    

    
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self addContact:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    // ensure user picked a phone property
   /* if (property == kABPersonPhoneProperty)
    {
        [self addContact:person withPhoneIdentifier:identifier];
    } */
    
    return NO;
}



- (void)addContact:(ABRecordRef)person //withPhoneIdentifier:(ABMultiValueIdentifier)identifier
{
    ABRecordID recordID = ABRecordGetRecordID(person);
    
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                         kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                        kABPersonLastNameProperty);
    
    // Check if contact already exists
    if ([self contactExists:recordID])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Exists"
                                                        message:[NSString stringWithFormat:@"You have already added %@ to your KIT contacts.", firstName]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        Contact *newContact = [[Contact alloc] initWithFirstName:firstName WithLastName:lastName WithABRecordID:recordID];

        [self.contactList.contacts addObject:newContact];
        
        [self.contactList saveContacts];
        
        [self.tableView reloadData];

        [self performSegueWithIdentifier:@"Contact" sender:newContact];
    }

}

- (BOOL)contactExists:(ABRecordID) recordID
{
    for (Contact *contact in self.contactList.contacts) {
        if (contact.recordID == recordID)
            return YES;
    }
    return NO;
}

- (void)contactDeleted:(Contact *) contact
{
    //NSUInteger index = [self.contactList.contacts indexOfObject:contact];
    //[self.tableView beginUpdates];
    [self.contactList.contacts removeObject:contact];
    //[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
    
    [self.contactList saveContacts];
}



#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.contactList.contacts count];
}

- (ContactListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Contact *currentContact = [self.contactList.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = currentContact.firstName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", currentContact.priority];
    cell.contact = currentContact;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactListCell *cell = (ContactListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Contact" sender:cell];
}





#pragma mark - Additional Table Methods

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
