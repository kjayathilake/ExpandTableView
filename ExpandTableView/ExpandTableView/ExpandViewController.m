//
//  ExpandViewController.m
//  ExpandTableView
//
// Copyright (c) 2014-2015 Krishantha Jayathilake
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ExpandViewController.h"
#import "TableViewCell.h"

/*!
 * @brief Number of table cells to be shown by default
 */
#define DEFAULT_SHOW_COUNT 3
/*!
 * @brief Height of the footer (Expand button)
 */
#define FOOTER_HEIGHT 44.0f
/*!
 * @brief Margin between footer and the next section
 */
#define FOOTER_MARGIN 10.0f

/*!
 * @brief Footer label for expand
 */
#define MORE_LABEL @"More"
/*!
 * @brief Footer label for shrink
 */
#define LESS_LABEL @"Less"

/*!
 * @brief Key for occurnces in table view cell
 */
#define OCCURANCE @"occurance"
/*!
 * @brief Key for label in table view cell
 */
#define VALUE @"value"
/*!
 * @brief Key for section label
 */
#define SECTION_LABEL @"label"
/*!
 * @brief Key for list items
 */
#define ITEMS @"items"

@interface ExpandViewController ()

/*!
 * @brief Saved preference for hiding sections
 */
@property NSMutableArray *hidePreference;
/*!
 * @brief Table view data source
 */
@property NSArray *listItems;

@end

@implementation ExpandViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Sample data for our table view.
    self.listItems = @[@{
                           @"items": @[
                                   @{@"occurance": @3,@"value": @"Apple"},
                                   @{@"occurance": @5,@"value": @"Orange"},
                                   @{@"occurance": @3,@"value": @"Banana"},
                                   @{@"occurance": @12,@"value": @"Pinapple"},
                                   @{@"occurance": @1,@"value": @"Peach"}],
                           @"label": @"Fruits"
                    }, @{
                           @"items": @[
                                   @{@"occurance": @56,@"value": @"Mac"},
                                   @{@"occurance": @42,@"value": @"Windows"},
                                   @{@"occurance": @39,@"value": @"Linux"}],
                           @"label": @"OS"
                    },@{
                           @"items": @[
                                   @{@"occurance": @14,@"value": @"Toyota"},
                                   @{@"occurance": @7,@"value": @"Honda"},
                                   @{@"occurance": @3,@"value": @"Porshe"},
                                   @{@"occurance": @16,@"value": @"Mitsubishi"},
                                   @{@"occurance": @8,@"value": @"Audi"},
                                   @{@"occurance": @8,@"value": @"Micro"}],
                           @"label": @"Cars"
                    },@{
                           @"items": @[
                                   @{@"occurance": @10,@"value": @"Apple"},
                                   @{@"occurance": @9,@"value": @"Samsung"},
                                   @{@"occurance": @2,@"value": @"LG"},
                                   @{@"occurance": @2,@"value": @"Nokia"}],
                           @"label": @"Phones"
                           
                    }];
    
    // initialize hiding preferences for sections.
    [self initiateHidePreference];
    // Load table.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 * @discussion Set hiding preference for each section based on their item count.
 */
- (void)initiateHidePreference {
    // Initialize array.
    self.hidePreference = [[NSMutableArray alloc]init];
    // Iterate through each section (Dictionary).
    for (NSDictionary *dictionary in self.listItems) {
        // Read number of items in section.
        NSInteger itemCount = [[dictionary valueForKey:ITEMS] count];
        // Enable hiding if number of items greater that default show count.
        [self.hidePreference addObject:[NSNumber numberWithBool:(itemCount > DEFAULT_SHOW_COUNT)]];
    }
}

/*!
 * @discussion Toggle section between show and hide its items.
 * @param recognizer Tap gesture recognizer
 */
- (void)togglelistItems:(UIGestureRecognizer*)recognizer {
    // Only respond if we're in the ended state (similar to touchupinside)
    if( [recognizer state] == UIGestureRecognizerStateEnded ) {
        // the label that was tapped.
        UILabel* label = (UILabel*)[recognizer view];
        // Read section number.
        NSInteger section = label.tag;
        if ([label.text isEqualToString:MORE_LABEL]) {
            // Set hiding preference to NO.
            [self.hidePreference replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:NO]];
            label.text = LESS_LABEL;
        } else {
            // Set hiding preference to YES.
            [self.hidePreference replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:YES]];
            label.text = MORE_LABEL;
        }
        // Reload sections with animation. While reloading the items will reveal or hide based on the preference we set earlier.
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.listItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSDictionary *listItemSection = self.listItems[section];
    return [[listItemSection valueForKey:ITEMS] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue table view cell.
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    // Get section.
    NSDictionary *listItemSection = self.listItems[indexPath.section];
    // Get items.
    NSDictionary *listItem = [listItemSection valueForKey:ITEMS][indexPath.row];
    // Get label text.
    cell.itemLabel.text = [listItem valueForKey:VALUE];
    // Get occurance value.
    cell.occurrencesLabel.text = [NSString stringWithFormat:@"%@ ",[listItem valueForKey:OCCURANCE]];
    // Get hide preference.
    BOOL hidden = [[self.hidePreference objectAtIndex:indexPath.section] boolValue];
    if(indexPath.row > DEFAULT_SHOW_COUNT - 1 && hidden){
        cell.hidden = YES;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *listItemsection = self.listItems[section];
    return [listItemsection valueForKey:SECTION_LABEL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL hidden = [[self.hidePreference objectAtIndex:indexPath.section] boolValue];
    if (indexPath.row > DEFAULT_SHOW_COUNT - 1 && hidden) {
        return 0;
    }
    return FOOTER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BOOL hidden = [[self.hidePreference objectAtIndex:section] boolValue];
    NSDictionary *dictionary = self.listItems[section];
    NSInteger itemCount = [[dictionary valueForKey:ITEMS] count];
    
    if(hidden) {
        // Create view for footer (expand button)
        UIView *moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), FOOTER_HEIGHT)];
        moreView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglelistItems:)];
        UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectInset(moreView.bounds, 0, 0)];
        moreLabel.text = MORE_LABEL;
        moreLabel.textAlignment = NSTextAlignmentCenter;
        moreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        moreLabel.backgroundColor = [UIColor whiteColor];
        moreLabel.textColor = [UIColor colorWithRed:32/255.0 green:80/255.0 blue:129/255.0 alpha:1];
        moreLabel.tag = section;
        [moreView addSubview:moreLabel];
        
        moreLabel.userInteractionEnabled = YES;
        [moreLabel addGestureRecognizer:tap];
        
        return moreView;
    } else if(itemCount > DEFAULT_SHOW_COUNT) {
        // Create view for footer (expand button)
        UIView *moreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), FOOTER_HEIGHT)];
        moreView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(togglelistItems:)];
        UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectInset(moreView.bounds, 0, 0)];
        moreLabel.text = LESS_LABEL;
        moreLabel.textAlignment = NSTextAlignmentCenter;
        moreLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        moreLabel.backgroundColor = [UIColor whiteColor];
        moreLabel.textColor = [UIColor colorWithRed:32/255.0 green:80/255.0 blue:129/255.0 alpha:1];
        moreLabel.tag = section;
        [moreView addSubview:moreLabel];
        
        moreLabel.userInteractionEnabled = YES;
        [moreLabel addGestureRecognizer:tap];
        
        return moreView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Determine height of the footer
    BOOL hidden = [[self.hidePreference objectAtIndex:section] boolValue];
    NSDictionary *dictionary = self.listItems[section];
    NSInteger itemCount = [[dictionary valueForKey:ITEMS] count];
    
    if (!hidden && itemCount <= DEFAULT_SHOW_COUNT) {
        // Set footer hight to 0
        return 0;
    }
    return FOOTER_HEIGHT + FOOTER_MARGIN;
}

@end
