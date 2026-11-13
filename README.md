# SmartShelf

SmartShelf helps small shops manage sales, stock, prices, customer debts, and daily profit reports.

## Authentication and cloud storage

SmartShelf uses [Supabase Auth](https://supabase.com/docs/guides/auth) for email/password accounts and a Supabase Postgres table for cloud data. Each account owns one shop-data record. Row Level Security (RLS) ensures a signed-in user can only read or change the record whose `user_id` matches their authenticated user ID.

### 1. Create a Supabase project

1. Create a project at https://supabase.com/.
2. In **Project Settings → API**, copy the Project URL and the **anon/public** key.
3. In **Authentication → Providers**, enable Email. Configure email confirmation to match how you want new accounts approved.

### 2. Create the database table and security policies

1. Open **SQL Editor** in the Supabase dashboard.
2. Open `supabase/schema.sql` from this repository, copy its contents, and run them.
3. Confirm that the `shop_data` table exists and Row Level Security is enabled.

### 3. Configure the browser app

1. Open `supabase-config.js`.
2. Replace `https://YOUR-PROJECT.supabase.co` with your Supabase Project URL.
3. Replace `YOUR_SUPABASE_ANON_KEY` with the project's anon/public key.
4. Commit the configured file to the repository.

The anon/public key is intended to be used in a browser. **Never put a Supabase `service_role` key, database password, or other server secret in this file or in frontend code.** The database RLS policies are essential; the anon key alone is not a security boundary.

### 4. Deploy

Deploy this repository as a static site with the repository root as the publish directory. The root `index.html` is the app entry point. Redeploy after configuring Supabase.

### 5. Existing device data

On the first successful sign-in for an account that has no cloud record yet, SmartShelf copies the existing device-local SmartShelf data into that account. After the cloud record is loaded, the old local copy is removed from that browser. Subsequent changes are saved to the signed-in account.

### Authentication behavior

- Email/password registration and sign-in are handled by Supabase Auth.
- Supabase manages password hashing, verification, and the browser session.
- The app does not read or store plaintext passwords.
- Password reset emails are initiated through Supabase Auth.
- Shop data is stored in `public.shop_data` as JSONB, scoped by the authenticated user's UUID.
- Row Level Security policies enforce per-account data isolation.

## Files

- `index.html` — SmartShelf app and authentication UI.
- `supabase-config.js` — public Supabase project URL and anon key configuration.
- `supabase/schema.sql` — database table and RLS policies.
- `render.yaml` — static-site deployment configuration.
