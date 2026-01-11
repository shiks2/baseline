// defaults values like margin, padding etc
const mobileSize = 600;

const defaultMargin = 16.0;
const doubleDefaultMargin = defaultMargin * 2;
const tripleDefaultMargin = defaultMargin * 3;
const halfDefaultMargin = defaultMargin / 2;
const fourthDefaultMargin = defaultMargin / 4;

const defaultPadding = 16.0;
const doubleDefaultPadding = 2 * defaultPadding;
const tripleDefaultPadding = 3 * defaultPadding;
const quadrapleDefaultPadding = 4 * defaultPadding;
const defaultBorderRadius = 16.0;
const defaultElevation = 5.0;
const double barWidthBase = 10;
// Static constants for compile-time usage
const double staticMobileSize = 600;
const double staticDefaultMargin = 16.0;
const double staticDoubleDefaultMargin = staticDefaultMargin * 2;
const double staticTripleDefaultMargin = staticDefaultMargin * 3;
const double staticHalfDefaultMargin = staticDefaultMargin / 2;
const double staticFourthDefaultMargin = staticDefaultMargin / 4;

const double staticDefaultPadding = 16.0;
const double staticDoubleDefaultPadding = 2 * staticDefaultPadding;
const double staticTripleDefaultPadding = 3 * staticDefaultPadding;
const double staticQuadrapleDefaultPadding = 4 * staticDefaultPadding;
const double staticDefaultBorderRadius = 16.0;
const double staticDefaultElevation = 5.0;
const double CARD_WIDTH = 370;
const double MAX_HEIGHT = 50;
const double ASSET_STATE_LEGEND_WIDTH = 100;
const double APPBAR_L_HEIGHT = 70;
const double APPBAR_M_HEIGHT = 50;
const double APPBAR_S_HEIGHT = 40;
const double MBLE_MRGN_MLTPLR = 0.02;
const double DSKTP_MRGN_MLTPLR = 0.01;
const double MBLE_CRD_WDTH_MLTPLR = 0.9;
const double MBLE_TWO_CRD_WDTH_MLTPLR = 0.40;
const double DSKTP_CRD_WDTH_MLTPLR = 0.4;
const double ACTN_BOX_WDTH_MLTPLR = 0.30;
const double MBLE_CHRT_HGHT_MLTPLR = 0.37;
const double DSKTP_CHRT_HGHT_MLTPLR = 0.30;
const double DSKTP_TABLE_HEIGHT_MLTPLR = 0.7;
const double GAP_MRGN_MLTPLR = 0.03;
const double colorRatio = 0.05;
const String SEPARATOR = ':';
// pathts routes

const SPLASH = '/';
const HOME = '/home';
const LOGIN = '/login';
const SIGNUP = '/signup';
const DASHBOARD = '/dashboard';

// Navigation labels
const String NAV_LIBRARY = 'Library';
const String NAV_ASSETS = 'Assets';
const String NAV_PROFILE = 'Profile';
const String NAV_INDEX_FILE = 'Index File';
const String NAV_SETTINGS = 'Settings';
const String NAV_MENU = 'Menu';

// App constants
const String APP_NAME = 'Candance';
const String DEFAULT_PAGE_CONTENT = 'Page Content Here';

// Auth constants
const String WELCOME_BACK = 'Welcome Back';
const String SIGN_IN_TO_ACCOUNT = 'Sign in to your account';
const String EMAIL_LABEL = 'Email';
const String PASSWORD_LABEL = 'Password';
const String SIGN_IN_BUTTON = 'Sign In';
const String CREATE_ACCOUNT = 'Create Account';
const String ALREADY_HAVE_ACCOUNT = 'Already have an account?';
const String DONT_HAVE_ACCOUNT = "Don't have an account?";
const String SIGN_UP_HERE = 'Sign up here';
const String SIGN_IN_HERE = 'Sign in here';

// api endpoints

// Profile Constants
const String PROFILE = 'Profile';
const String EDIT_PROFILE = 'Edit Profile';
const String PROFILE_SETTINGS = 'Profile Settings';
const String FULL_NAME = 'Full Name';
const String EMAIL_ADDRESS = 'Email Address';
const String PHONE_NUMBER = 'Phone Number';
const String BIO = 'Bio';
const String LOCATION = 'Location';
const String WEBSITE = 'Website';
const String SAVE_CHANGES = 'Save Changes';
const String CANCEL = 'Cancel';
const String CHANGE_PHOTO = 'Change Photo';
const String REMOVE_PHOTO = 'Remove Photo';
const String PROFILE_UPDATED = 'Profile updated successfully';
const String PROFILE_UPDATE_FAILED = 'Failed to update profile';
const String SELECT_IMAGE = 'Select Image';
const String CAMERA = 'Camera';
const String GALLERY = 'Gallery';
const String SETTINGS = 'Settings';
const String PREFERENCES = 'Preferences';
const String NOTIFICATIONS = 'Notifications';
const String PRIVACY = 'Privacy';
const String SECURITY = 'Security';
const String THEME = 'Theme';
const String LANGUAGE = 'Language';
const String LOGOUT = 'Logout';
const String DELETE_ACCOUNT = 'Delete Account';
const String ARE_YOU_SURE = 'Are you sure?';
const String DELETE_ACCOUNT_WARNING =
    'This action cannot be undone. All your data will be permanently deleted.';
const String CONFIRM_DELETE = 'Confirm Delete';

// Profile Routes
const PROFILE_ROUTE = '/profile';
const EDIT_PROFILE_ROUTE = '/profile/edit';
const PROFILE_SETTINGS_ROUTE = '/profile/settings';

// Indexer Constants
const String INDEX_FILE = 'Index File';
const String SELECT_FOLDERS = 'Select Folders';
const String ADD_FOLDER = 'Add Folder';
const String REMOVE_FOLDER = 'Remove';
const String START_INDEXING = 'Start Indexing';
const String STOP_INDEXING = 'Stop Indexing';
const String INDEXING_STATUS = 'Indexing Status';
const String FOLDERS_TO_INDEX = 'Folders to Index';
const String NO_FOLDERS_SELECTED = 'No folders selected';
const String FOLDER_ALREADY_ADDED = 'Folder already added';
const String SELECT_FOLDER_TO_INDEX = 'Select a folder to index';
const String INDEXING_STARTED = 'Indexing started';
const String INDEXING_STOPPED = 'Indexing stopped';
const String INDEXING_COMPLETED = 'Indexing completed';
const String INDEXING_FAILED = 'Indexing failed';
const String FOLDER_REMOVED = 'Folder removed';
const String FOLDER_ADDED = 'Folder added';
const String INDEXING_IN_PROGRESS = 'Indexing in progress...';
const String INDEXING_IDLE = 'Ready to index';
const String FILES_INDEXED = 'files indexed';
const String INDEXER_ROUTE = '/indexer';
