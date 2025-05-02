//
//  ContactsViewController.m
//  contactsAppTest
//
//  Created by LorenzoAC on 4/30/25.
//

// ContactsViewController.m
#import "ContactsViewController.h"
#import "contactsAppTest-Swift.h"


@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSMutableArray *filteredContacts;
@property (nonatomic, assign) BOOL isFiltering;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Lista de Contactos";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupSearchBar];
    [self setupTableView];
    
//    self.contacts = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedContacts"] mutableCopy];
    /*NSArray *savedArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedContacts"];
    self.contacts = [NSMutableArray array];

    for (NSDictionary *contactDict in savedArray) {
        NSString *firstName = contactDict[@"firstName"];
        NSString *lastName = contactDict[@"lastName"];
        NSString *contactString = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        [self.contacts addObject:contactString];
    }*/
    [self loadContactsFromUserDefaults];
    self.filteredContacts = [NSMutableArray array];
}
- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];
    [self loadContactsFromUserDefaults];
}

#pragma mark - Setup UI

- (void)setupNavigationBar {
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
        initWithTitle:@"Nuevo"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(addContact)];

    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
        initWithTitle:@"Borrar"
                style:UIBarButtonItemStylePlain
               target:self
               action:@selector(deleteAllContacts)];

    
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = deleteButton;

    
    self.navigationItem.title = @"Lista de Contactos";
}


/*- (void)setupNavigationBar {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                             target:self
                             action:@selector(addContact)];
    
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                             target:self
                             action:@selector(deleteAllContacts)];

    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = trashButton;
}*/

- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Buscar contacto";
    self.searchBar.delegate = self;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.searchBar.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.searchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"contactCell"];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

#pragma mark - Navigation Bar Actions

- (void)addContact {
    NSLog(@"Agregar contacto");

   /* AddContactViewController *swiftUIController = [[AddContactViewController alloc] init];

    __weak typeof(self) weakSelf = self;
    swiftUIController.onSave = ^(ContactDataWrapper * _Nonnull contact) {
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
        [weakSelf.contacts addObject:fullName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    };

    [self presentViewController:swiftUIController animated:YES completion:nil];*/
}

- (void)deleteAllContacts {
    [self.contacts removeAllObjects];
    [self.filteredContacts removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isFiltering ? self.filteredContacts.count : self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    NSString *contactName = self.isFiltering ? self.filteredContacts[indexPath.row] : self.contacts[indexPath.row];
    cell.textLabel.text = contactName;
    return cell;
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.isFiltering = searchText.length > 0;
    [self.filteredContacts removeAllObjects];
    
    for (NSString *contact in self.contacts) {
        if ([[contact lowercaseString] containsString:[searchText lowercaseString]]) {
            [self.filteredContacts addObject:contact];
        }
    }
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isFiltering = NO;
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}


- (void)loadContactsFromUserDefaults {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedContacts"];
    self.contacts = [NSMutableArray array];

    if ([data isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        NSArray *decodedArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"Error decoding contacts from UserDefaults: %@", error);
        } else if ([decodedArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in decodedArray) {
                NSString *fullName = [NSString stringWithFormat:@"%@ %@",
                                      dict[@"firstName"] ?: @"",
                                      dict[@"lastName"] ?: @""];
                [self.contacts addObject:fullName];
            }
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


@end
