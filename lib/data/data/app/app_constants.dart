/// App-wide constants and enums.
library;

/// App version — update this on each release.
const kAppVersion = '2.0.0+1';

/// Auth method used during login.
enum AuthMethod { email, phone }

/// Which backend the app is currently using.
enum BackendType { firebase, supabase, http, mock }
