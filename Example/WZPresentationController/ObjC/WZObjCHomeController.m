//
//  WZObjCHomeController.m
//  WZPresentationController
//
//  Created by 吴哲 on 2018/10/12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "WZObjCHomeController.h"
#import "WZObjCAlertView.h"


@interface WZObjCHomeCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

@implementation WZObjCHomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    WZObjCHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WZObjCHomeCell"];
    if (cell == nil) {
        cell = [[WZObjCHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WZObjCHomeCell"];
        cell.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.7];
        cell.textLabel.textColor = UIColor.darkTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:20.f];
    }
    return cell;
}

@end

@interface WZObjCHomeController ()
/// items
@property(nonatomic ,copy) NSArray<NSArray<NSString *> *> *items;
/// maskEffect
@property(nonatomic ,strong) UIBlurEffect *maskEffect;
@end

@implementation WZObjCHomeController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat"]];
        self.tableView.backgroundView = imageView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _items = @[
               @[
                   @"normal",
                   @"fade",
                   @"dropDown",
                   ],
               @[
                   @"normal"
                   ]
               ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"maskEffect" style:UIBarButtonItemStylePlain target:self action:@selector(maskEffectSetting)];
}

- (void)maskEffectSetting
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"effect" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"none" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.maskEffect = nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"extraLight" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.maskEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"light" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.maskEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"dark" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.maskEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }]];
    if (@available(iOS 10.0, *)) {
        [alert addAction:[UIAlertAction actionWithTitle:@"regular" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.maskEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"prominent" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.maskEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WZObjCHomeCell cellWithTableView:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"alert";
    }
    return @"sheet";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(WZObjCHomeCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = self.items[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:UITableViewHeaderFooterView.class]) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.textColor = UIColor.groupTableViewBackgroundColor;
        header.textLabel.font = [UIFont boldSystemFontOfSize:24.f];
        header.textLabel.text = header.textLabel.text.lowercaseString;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WZObjCAlertView *alertView = [WZObjCAlertView new];
    alertView.maskEffect = self.maskEffect;
    [alertView showWithAnimated:YES completion:nil];
}

@end
