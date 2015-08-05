//
//  TableViewCell.h
//  ExpandTableView
//
//  Created by Krishantha Jayathilake  on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

/*!
 * @brief itemLabel Facet Name
 */
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;

/*!
 * @brief occurrencesLabel No of documents related to facet
 */
@property (weak, nonatomic) IBOutlet UILabel *occurrencesLabel;

@end
