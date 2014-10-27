//
//  FiltersViewController.m
//  Yelp
//
//  Created by Alan McConnell on 10/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableSet *selectedCategories;

@property (assign, nonatomic) BOOL categoriesExpanded;
@property (assign, nonatomic) BOOL distanceExpanded;
@property (assign, nonatomic) BOOL sortExpanded;

@property (readonly, nonatomic) NSDictionary *filters;
@property (assign, nonatomic) BOOL deal;
@property (assign, nonatomic) int distance;
@property (assign, nonatomic) int sortBy;

@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
        
        self.deal = NO;
        self.distance = 0;
        self.sortBy = 0;
        
        self.categoriesExpanded = NO;
        self.distanceExpanded = NO;
        self.sortExpanded = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(onApply)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"General Features";
        case 1:
            return @"Distance";
        case 2:
            return @"Sort By";
        case 3:
            return @"Categories";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // General Features
    if (section == 0) {
        return 1;
    }

    // Distance
    if (section == 1) {
        if (self.distanceExpanded) {
            return 4;
        } else {
            return 1;
        }
    }

    // Sort
    if (section == 2) {
        if (self.sortExpanded) {
            return 3;
        } else {
            return 1;
        }
    }
    

    // Categories section
    if (section == 3) {
        if (self.categoriesExpanded) {
            return self.categories.count;
        } else {
            return 6;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // General Features section
    if (indexPath.section == 0) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.titleLabel.text = @"Offering a Deal";
        cell.on = self.deal;
        cell.delegate = self;
        return cell;
    }

    // Distance section
    if (indexPath.section == 1) {
        NSArray *distanceNames =
        @[
          @"1 mile",
          @"5 miles",
          @"10 miles",
          @"20 miles",
        ];

        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        if (self.distanceExpanded) {
            cell.titleLabel.text = distanceNames[indexPath.row];
            cell.on = indexPath.row == self.distance;
            cell.enabled = !cell.on;
            cell.delegate = self;
        } else {
            cell.titleLabel.text = distanceNames[self.distance];
            cell.on = YES;
            cell.enabled = NO;
        }
        return cell;
    }

    // Sort By section
    if (indexPath.section == 2) {
        NSArray *sortByNames =
        @[
          @"Best Match",
          @"Distance",
          @"Highest Rated",
          ];
        
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        if (self.sortExpanded) {
            cell.titleLabel.text = sortByNames[indexPath.row];
            cell.on = indexPath.row == self.sortBy;
            cell.enabled = !cell.on;
            cell.delegate = self;
        } else {
            cell.titleLabel.text = sortByNames[self.sortBy];
            cell.on = YES;
            cell.enabled = NO;
        }
        return cell;
    }
    
    // Categories section
    if (indexPath.section == 3) {
        if (!self.categoriesExpanded && indexPath.row == 5) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:@"CategorySeeAll"];
            cell.textLabel.text = @"See All";
            return cell;
        } else {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
            cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
            cell.delegate = self;
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        if (!self.distanceExpanded) {
            self.distanceExpanded = YES;
        }
    }
 
    if (indexPath.section == 2) {
        if (!self.sortExpanded) {
            self.sortExpanded = YES;
        }
    }
    if (indexPath.section == 3) {
        if (!self.categoriesExpanded) {
            self.categoriesExpanded = YES;
        }
    }

    [self tableView:tableView reloadSection:(int)indexPath.section];
}

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // General Features (deal) Section
    if (indexPath.section == 0) {
        self.deal = value;
    }

    // Distance Section
    if (indexPath.section == 1) {
        self.distance = (int)indexPath.row;
        self.distanceExpanded = NO;
        [self tableView:self.tableView reloadSection:1];
    }
    
    // Distance Section
    if (indexPath.section == 2) {
        self.sortBy = (int)indexPath.row;
        self.sortExpanded = NO;
        [self tableView:self.tableView reloadSection:2];
    }
    
    // Categories Section
    if (indexPath.section == 3) {
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    if (self.selectedCategories.count > 0) {
        NSMutableArray *categoryNames = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [categoryNames addObject:category[@"code"]];
        }
        NSString *categoryString = [categoryNames componentsJoinedByString:@","];
        [filters setObject:categoryString forKey:@"category_filter"];
    }
    
    int actualDistance = 0;
    switch (self.distance) {
        case 0:
            actualDistance = 1;
        case 1:
            actualDistance = 5;
        case 2:
            actualDistance = 10;
        case 3:
            actualDistance = 20;
    }
    int meters = actualDistance * 1609.34; // meters / mile
    [filters setValue:[NSNumber numberWithInt:meters] forKey:@"radius_filter"];
    [filters setValue:[NSNumber numberWithInt:self.sortBy] forKey:@"sort"];
    [filters setValue:[NSNumber numberWithBool:self.deal] forKey:@"deals_filter"];

    return filters;
}
- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApply {
    [self.delegate filtersViewControllers:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView*)tableView reloadSection:(int)section {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)initCategories {
    self.categories =
    @[
      @{@"name" : @"Afghan", @"code": @"afghani" },
      @{@"name" : @"African", @"code": @"african" },
      @{@"name" : @"American, New", @"code": @"newamerican" },
      @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
      @{@"name" : @"Arabian", @"code": @"arabian" },
      @{@"name" : @"Argentine", @"code": @"argentine" },
      @{@"name" : @"Armenian", @"code": @"armenian" },
      @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
      @{@"name" : @"Asturian", @"code": @"asturian" },
      @{@"name" : @"Australian", @"code": @"australian" },
      @{@"name" : @"Austrian", @"code": @"austrian" },
      @{@"name" : @"Baguettes", @"code": @"baguettes" },
      @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
      @{@"name" : @"Barbeque", @"code": @"bbq" },
      @{@"name" : @"Basque", @"code": @"basque" },
      @{@"name" : @"Bavarian", @"code": @"bavarian" },
      @{@"name" : @"Beer Garden", @"code": @"beergarden" },
      @{@"name" : @"Beer Hall", @"code": @"beerhall" },
      @{@"name" : @"Beisl", @"code": @"beisl" },
      @{@"name" : @"Belgian", @"code": @"belgian" },
      @{@"name" : @"Bistros", @"code": @"bistros" },
      @{@"name" : @"Black Sea", @"code": @"blacksea" },
      @{@"name" : @"Brasseries", @"code": @"brasseries" },
      @{@"name" : @"Brazilian", @"code": @"brazilian" },
      @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
      @{@"name" : @"British", @"code": @"british" },
      @{@"name" : @"Buffets", @"code": @"buffets" },
      @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
      @{@"name" : @"Burgers", @"code": @"burgers" },
      @{@"name" : @"Burmese", @"code": @"burmese" },
      @{@"name" : @"Cafes", @"code": @"cafes" },
      @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
      @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
      @{@"name" : @"Cambodian", @"code": @"cambodian" },
      @{@"name" : @"Canadian", @"code": @"New)" },
      @{@"name" : @"Canteen", @"code": @"canteen" },
      @{@"name" : @"Caribbean", @"code": @"caribbean" },
      @{@"name" : @"Catalan", @"code": @"catalan" },
      @{@"name" : @"Chech", @"code": @"chech" },
      @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
      @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
      @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
      @{@"name" : @"Chilean", @"code": @"chilean" },
      @{@"name" : @"Chinese", @"code": @"chinese" },
      @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
      @{@"name" : @"Corsican", @"code": @"corsican" },
      @{@"name" : @"Creperies", @"code": @"creperies" },
      @{@"name" : @"Cuban", @"code": @"cuban" },
      @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
      @{@"name" : @"Cypriot", @"code": @"cypriot" },
      @{@"name" : @"Czech", @"code": @"czech" },
      @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
      @{@"name" : @"Danish", @"code": @"danish" },
      @{@"name" : @"Delis", @"code": @"delis" },
      @{@"name" : @"Diners", @"code": @"diners" },
      @{@"name" : @"Dumplings", @"code": @"dumplings" },
      @{@"name" : @"Eastern European", @"code": @"eastern_european" },
      @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
      @{@"name" : @"Fast Food", @"code": @"hotdogs" },
      @{@"name" : @"Filipino", @"code": @"filipino" },
      @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
      @{@"name" : @"Fondue", @"code": @"fondue" },
      @{@"name" : @"Food Court", @"code": @"food_court" },
      @{@"name" : @"Food Stands", @"code": @"foodstands" },
      @{@"name" : @"French", @"code": @"french" },
      @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
      @{@"name" : @"Galician", @"code": @"galician" },
      @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
      @{@"name" : @"Georgian", @"code": @"georgian" },
      @{@"name" : @"German", @"code": @"german" },
      @{@"name" : @"Giblets", @"code": @"giblets" },
      @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
      @{@"name" : @"Greek", @"code": @"greek" },
      @{@"name" : @"Halal", @"code": @"halal" },
      @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
      @{@"name" : @"Heuriger", @"code": @"heuriger" },
      @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
      @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
      @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
      @{@"name" : @"Hot Pot", @"code": @"hotpot" },
      @{@"name" : @"Hungarian", @"code": @"hungarian" },
      @{@"name" : @"Iberian", @"code": @"iberian" },
      @{@"name" : @"Indian", @"code": @"indpak" },
      @{@"name" : @"Indonesian", @"code": @"indonesian" },
      @{@"name" : @"International", @"code": @"international" },
      @{@"name" : @"Irish", @"code": @"irish" },
      @{@"name" : @"Island Pub", @"code": @"island_pub" },
      @{@"name" : @"Israeli", @"code": @"israeli" },
      @{@"name" : @"Italian", @"code": @"italian" },
      @{@"name" : @"Japanese", @"code": @"japanese" },
      @{@"name" : @"Jewish", @"code": @"jewish" },
      @{@"name" : @"Kebab", @"code": @"kebab" },
      @{@"name" : @"Korean", @"code": @"korean" },
      @{@"name" : @"Kosher", @"code": @"kosher" },
      @{@"name" : @"Kurdish", @"code": @"kurdish" },
      @{@"name" : @"Laos", @"code": @"laos" },
      @{@"name" : @"Laotian", @"code": @"laotian" },
      @{@"name" : @"Latin American", @"code": @"latin" },
      @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
      @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
      @{@"name" : @"Malaysian", @"code": @"malaysian" },
      @{@"name" : @"Meatballs", @"code": @"meatballs" },
      @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
      @{@"name" : @"Mexican", @"code": @"mexican" },
      @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
      @{@"name" : @"Milk Bars", @"code": @"milkbars" },
      @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
      @{@"name" : @"Modern European", @"code": @"modern_european" },
      @{@"name" : @"Mongolian", @"code": @"mongolian" },
      @{@"name" : @"Moroccan", @"code": @"moroccan" },
      @{@"name" : @"New Zealand", @"code": @"newzealand" },
      @{@"name" : @"Night Food", @"code": @"nightfood" },
      @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
      @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
      @{@"name" : @"Oriental", @"code": @"oriental" },
      @{@"name" : @"Pakistani", @"code": @"pakistani" },
      @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
      @{@"name" : @"Parma", @"code": @"parma" },
      @{@"name" : @"Persian/Iranian", @"code": @"persian" },
      @{@"name" : @"Peruvian", @"code": @"peruvian" },
      @{@"name" : @"Pita", @"code": @"pita" },
      @{@"name" : @"Pizza", @"code": @"pizza" },
      @{@"name" : @"Polish", @"code": @"polish" },
      @{@"name" : @"Portuguese", @"code": @"portuguese" },
      @{@"name" : @"Potatoes", @"code": @"potatoes" },
      @{@"name" : @"Poutineries", @"code": @"poutineries" },
      @{@"name" : @"Pub Food", @"code": @"pubfood" },
      @{@"name" : @"Rice", @"code": @"riceshop" },
      @{@"name" : @"Romanian", @"code": @"romanian" },
      @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
      @{@"name" : @"Rumanian", @"code": @"rumanian" },
      @{@"name" : @"Russian", @"code": @"russian" },
      @{@"name" : @"Salad", @"code": @"salad" },
      @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
      @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
      @{@"name" : @"Scottish", @"code": @"scottish" },
      @{@"name" : @"Seafood", @"code": @"seafood" },
      @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
      @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
      @{@"name" : @"Singaporean", @"code": @"singaporean" },
      @{@"name" : @"Slovakian", @"code": @"slovakian" },
      @{@"name" : @"Soul Food", @"code": @"soulfood" },
      @{@"name" : @"Soup", @"code": @"soup" },
      @{@"name" : @"Southern", @"code": @"southern" },
      @{@"name" : @"Spanish", @"code": @"spanish" },
      @{@"name" : @"Steakhouses", @"code": @"steak" },
      @{@"name" : @"Sushi Bars", @"code": @"sushi" },
      @{@"name" : @"Swabian", @"code": @"swabian" },
      @{@"name" : @"Swedish", @"code": @"swedish" },
      @{@"name" : @"Swiss Food", @"code": @"swissfood" },
      @{@"name" : @"Tabernas", @"code": @"tabernas" },
      @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
      @{@"name" : @"Tapas Bars", @"code": @"tapas" },
      @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
      @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
      @{@"name" : @"Thai", @"code": @"thai" },
      @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
      @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
      @{@"name" : @"Trattorie", @"code": @"trattorie" },
      @{@"name" : @"Turkish", @"code": @"turkish" },
      @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
      @{@"name" : @"Uzbek", @"code": @"uzbek" },
      @{@"name" : @"Vegan", @"code": @"vegan" },
      @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
      @{@"name" : @"Venison", @"code": @"venison" },
      @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
      @{@"name" : @"Wok", @"code": @"wok" },
      @{@"name" : @"Wraps", @"code": @"wraps" },
      @{@"name" : @"Yugoslav", @"code": @"yugoslav" },
  ];
}
    
@end
