//
//  ITPShareController.m
//  iTunesPicker
//
//  Created by Denis Berton on 19/07/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPShareController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@implementation ITPShareController<ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>
    @property (strong, nonatomic) SLComposeViewController *mySLComposerSheet;
@end


#pragma mark - ABPeoplePickerDelegate

/* Called when the user cancels the address book view controller. We simply dismiss it. */
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Called when a member of the address book is selected, we return YES to display the member's details. */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

/* Called when the user selects a property of a person in their address book (ex. phone, email, location,...)
 This method will allow them to send a text or email inviting them to Anypic.  */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    if (property == kABPersonEmailProperty) {
        
        ABMultiValueRef emailProperty = ABRecordCopyValue(person,property);
        NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emailProperty,identifier);
        self.selectedEmailAddress = email;
        
        if ([MFMailComposeViewController canSendMail] && [MFMessageComposeViewController canSendText]) {
            // ask user
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"findFriends.sheet.invite",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"button.generic.cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"findFriends.sheet.email",nil), NSLocalizedString(@"findFriends.sheet.iMessage",nil), nil];
            UIWindow* window = [[UIApplication sharedApplication] keyWindow];
            //[actionSheet showFromTabBar:self.tabBarController.tabBar];
            [actionSheet showInView:window];
        } else if ([MFMailComposeViewController canSendMail]) {
            // go directly to mail
            [self presentMailComposeViewController:email];
        } else if ([MFMessageComposeViewController canSendText]) {
            // go directly to iMessage
            [self presentMessageComposeViewController:email];
        }
        
    } else if (property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
        NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneProperty,identifier);
        
        if ([MFMessageComposeViewController canSendText]) {
            [self presentMessageComposeViewController:phone];
        }
    }
    
    return NO;
}

#pragma mark - MFMailComposeDelegate

/* Simply dismiss the MFMailComposeViewController when the user sends an email or cancels */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MFMessageComposeDelegate

/* Simply dismiss the MFMessageComposeViewController when the user sends a text or cancels */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if(actionSheet.tag == 100)
    {
        if (buttonIndex == 0) {
            [self inviteFriendsFromFacebook];
        }
        else if (buttonIndex == 1) {
            [self postMessageOnFacebook];
        }
        else{
            [self inviteFriendsFromContacts];
        }
    }
    else{
        if (buttonIndex == 0) {
            [self presentMailComposeViewController:self.selectedEmailAddress];
        } else if (buttonIndex == 1) {
            [self presentMessageComposeViewController:self.selectedEmailAddress];
        }
    }
}

- (void)inviteFriendsButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"button.generic.cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"invite.sheet.facebook", nil),NSLocalizedString(@"invite.sheet.post.facebook", nil),NSLocalizedString(@"invite.sheet.contacts", nil), nil];
    actionSheet.tag = 100;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)inviteFriendsFromContacts {
    ABPeoplePickerNavigationController *addressBook = [[ABPeoplePickerNavigationController alloc] init];
    addressBook.peoplePickerDelegate = self;
    
    if ([MFMailComposeViewController canSendMail] && [MFMessageComposeViewController canSendText]) {
        addressBook.displayedProperties = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonEmailProperty], [NSNumber numberWithInt:kABPersonPhoneProperty], nil];
    } else if ([MFMailComposeViewController canSendMail]) {
        addressBook.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]];
    } else if ([MFMessageComposeViewController canSendText]) {
        addressBook.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    }
    
    [self presentViewController:addressBook animated:YES completion:nil];
}

- (void)presentMailComposeViewController:(NSString *)recipient {
    // Create the compose email view controller
    MFMailComposeViewController *composeEmailViewController = [[MFMailComposeViewController alloc] init];
    
    // Set the recipient to the selected email and a default text
    [composeEmailViewController setMailComposeDelegate:self];
    [composeEmailViewController setSubject: NSLocalizedString(@"findFriends.mail.subject",nil)];
    [composeEmailViewController setToRecipients:[NSArray arrayWithObjects:recipient, nil]];
    [composeEmailViewController setMessageBody:NSLocalizedString(@"findFriends.mail.text",nil) isHTML:YES];
    
    // Dismiss the current modal view controller and display the compose email one.
    // Note that we do not animate them. Doing so would require us to present the compose
    // mail one only *after* the address book is dismissed.
    [self dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:composeEmailViewController animated:NO completion:nil];
    }];
    
}

- (void)presentMessageComposeViewController:(NSString *)recipient {
    // Create the compose text message view controller
    MFMessageComposeViewController *composeTextViewController = [[MFMessageComposeViewController alloc] init];
    
    // Send the destination phone number and a default text
    [composeTextViewController setMessageComposeDelegate:self];
    [composeTextViewController setRecipients:[NSArray arrayWithObjects:recipient, nil]];
    [composeTextViewController setBody:NSLocalizedString(@"findFriends.mail.body",nil)];
    
    // Dismiss the current modal view controller and display the compose text one.
    // See previous use for reason why these are not animated.
    [self dismissViewControllerAnimated:NO completion:^{
        [self presentViewController:composeTextViewController animated:NO completion:nil];
    }];
    
}

-(void) postMessageOnFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        self.mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [self.mySLComposerSheet setInitialText:NSLocalizedString(@"fb.post.message",nil)]; //the message you want to post
        [self.mySLComposerSheet addImage:[UIImage imageNamed:@"share.icon.png"]]; //an image you could post
        [self.mySLComposerSheet addURL:[NSURL URLWithString:@"http://itunes.com/apps/appcorner"]];  //replace with https://itunes.apple.com/us/app/keynote/id361285480?mt=8
        //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
        [self presentViewController:self.mySLComposerSheet animated:YES completion:nil];
    }
    [self.mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSLog(@"SLComposeViewController for facebook not available.");
        //        NSString *output;
        //        switch (result) {
        //            case SLComposeViewControllerResultCancelled:
        //            output = @"Action Cancelled";
        //            break;
        //            case SLComposeViewControllerResultDone:
        //            output = @"Post Successfull";
        //            break;
        //            default:
        //            break;
        //        } //check if everythink worked properly. Give out a message on the state.
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        //        [alert show];
    }];
}

- (void)showShareSheet {
    
    UIImage* image = [self.headerView.appImageScrollView getCurrentImage];
    NSMutableArray *activityItems = [NSMutableArray arrayWithCapacity:6];
    
    [activityItems addObject:self.app.name];
    //            [activityItems addObject:[UIImage imageWithData:data]];
    [activityItems addObject:image];
    
    [activityItems addObject:NSLocalizedString(@"share.post.message",nil)];
    [activityItems addObject:[NSURL URLWithString:@"http://itunes.com/apps/appcorner"]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[]];
    [activityViewController setValue:self.app.name forKey:@"subject"];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard];
    
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}
