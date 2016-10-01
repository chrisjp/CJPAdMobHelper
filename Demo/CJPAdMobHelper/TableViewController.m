//
//  TableViewController.m
//  CJPAdMobHelper
//
//  Created by Chris Phillips on 30/09/2016.
//  Copyright © 2016 Midnight Labs Ltd. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad && [UIScreen mainScreen].bounds.size.height==1366) {
        return 88;
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return 66;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"This is an example";
            break;
        case 1:
            cell.textLabel.text = @"of a view";
            break;
        case 2:
            cell.textLabel.text = @"with a lot";
            break;
        case 3:
            cell.textLabel.text = @"of scrollable content";
            break;
        case 4:
            cell.textLabel.text = @"to show that";
            break;
        case 5:
            cell.textLabel.text = @"none of it";
            break;
        case 6:
            cell.textLabel.text = @"gets cut off";
            break;
        case 7:
            cell.textLabel.text = @"or gets hidden";
            break;
        case 8:
            cell.textLabel.text = @"behind the ad banner";
            break;
        case 9:
            cell.textLabel.text = @"at the bottom.";
            break;
        case 10:
            cell.textLabel.text = @"You don't even";
            break;
        case 11:
            cell.textLabel.text = @"need to add";
            break;
        case 12:
            cell.textLabel.text = @"any constraints";
            break;
        case 13:
            cell.textLabel.text = @"or make any changes";
            break;
        case 14:
            cell.textLabel.text = @"to your storyboards.";
            break;
        case 15:
            cell.textLabel.text = @"The banner sticks";
            break;
        case 16:
            cell.textLabel.text = @"across all your views.";
            break;
        case 17:
            cell.textLabel.text = @"Simple.";
            break;
            
        default:
            break;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
