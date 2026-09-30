# Sign-in emails

The app signs people in with a six-digit code, never a link
(`lib/backend/supabase_backend.dart`: `updateUser` + `verifyOTP(emailChange)`
to add an email to a new account, `signInWithOtp` + `verifyOTP(email)` to sign
in). Supabase's default templates send a link instead, and with the Site URL
left at its default that link pointed at `http://localhost:3000` — which is
what people got until 2026-09-30.

These two files are the templates pasted into the Supabase dashboard
(Authentication → Emails → Templates). Supabase keeps them; this is the copy to
paste from if they ever need changing.

| Template in Supabase | File | Subject |
|---|---|---|
| Change Email Address — a new account adding its email | `change-email-address.html` | `Your OUTREPD code: {{ .Token }}` |
| Magic Link — signing in to an existing account | `magic-link.html` | `Your OUTREPD sign-in code: {{ .Token }}` |

Also set in the dashboard:

- Authentication → URL Configuration → **Site URL** = `https://www.outrepd.com`
- Authentication → Sign In / Providers → Email → **Email OTP Length** = `6`
  (the app's code boxes are six; `_kCodeLength` in `lib/screens/auth_entry.dart`)

`{{ .Token }}` is the code and `{{ .NewEmail }}` the address being added;
Supabase fills both in.
