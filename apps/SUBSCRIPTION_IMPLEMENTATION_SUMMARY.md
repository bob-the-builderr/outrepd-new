# Subscription Security & Data Integrity Implementation

## ✅ What Was Implemented

### 1. Database Schema Changes
Added subscription tracking to `user_profiles`:
- `subscription_status` - Current status (free, active, cancelled, expired, billing_issue)
- `subscription_expires_at` - Expiration timestamp
- `subscription_tier` - Tier name (free, premium, elite, etc.)

Created `subscriptions` table for complete history:
- Tracks all RevenueCat webhook events
- Stores raw event data for audit trail
- Indexed for fast queries by user, status, and expiration

### 2. RevenueCat Webhook Handler
**Location**: `/apps/web/src/app/api/webhooks/revenuecat/route.js`

Handles all subscription lifecycle events:
- INITIAL_PURCHASE - First subscription purchase
- RENEWAL - Automatic renewal
- CANCELLATION - User cancelled (still active until expiration)
- UNCANCELLATION - User re-enabled auto-renewal
- EXPIRATION - Subscription expired
- BILLING_ISSUE - Payment failed
- PRODUCT_CHANGE - User changed tiers

### 3. Subscription Middleware
**Location**: `/apps/web/src/app/api/utils/subscription-middleware.js`

Two main functions:
- `requireSubscription()` - Throws error if no valid subscription (use for premium-only routes)
- `checkSubscription()` - Returns subscription status without throwing (use for freemium features)

### 4. API Endpoints

#### `/api/subscription/sync` (POST)
Manually sync subscription status from database. Called automatically after purchase/restore.

#### `/api/subscription/status` (GET)
Get current subscription status for authenticated user.

#### `/api/subscription/history` (GET)
View subscription event history for authenticated user.

#### `/api/admin/subscriptions` (GET)
Admin endpoint to view all subscriptions (add proper admin auth before using in production).

### 5. Mobile App Integration
**Updated**: `/apps/mobile/src/utils/iap/useInAppPurchase.js`

Changes:
- `initiate(userId)` now accepts userId and sets it in RevenueCat
- Automatically syncs with backend after purchase/restore
- Critical: User ID must be set for webhooks to work

## 🔧 Setup Required

### 1. Configure RevenueCat Webhook
1. Go to RevenueCat dashboard → Project Settings → Integrations → Webhooks
2. Add webhook URL: `https://your-domain.com/api/webhooks/revenuecat`
3. Select all event types to send
4. (Optional) Add authorization header for security

See: `/apps/web/src/app/api/webhooks/revenuecat/README.md`

### 2. Update Product ID Mapping
Edit the `mapProductIdToTier()` function in the webhook handler to match your RevenueCat product IDs:

```javascript
function mapProductIdToTier(productId) {
  // Update these to match your actual product IDs
  if (productId.includes('premium')) return 'premium';
  if (productId.includes('elite')) return 'elite';
  return 'premium';
}
```

### 3. Update Mobile App to Pass User ID
Find where you initialize IAP in your app and update it:

```javascript
// Before
const { initiate } = useInAppPurchase();
await initiate();

// After
const { initiate } = useInAppPurchase();
const session = await getSession(); // Or however you get user
await initiate(session.user.id); // Pass user ID
```

Example location: `/apps/mobile/src/app/_layout.jsx` or wherever you initialize IAP

### 4. Protect Premium Routes
Add subscription verification to premium API routes:

```javascript
import { requireSubscription } from "@/app/api/utils/subscription-middleware";

export async function POST(request) {
  // Only allow subscribers
  const { userId, profile } = await requireSubscription(request);
  
  // Your premium feature code here
  return Response.json({ success: true });
}
```

See full guide: `/apps/web/src/app/api/utils/SUBSCRIPTION_MIDDLEWARE_GUIDE.md`

## 🔐 Security Features

### Server-Side Verification
All subscription checks happen server-side. Users cannot bypass payment by modifying client code.

### Automatic Expiration
Webhook automatically marks subscriptions as expired when they run out.

### Audit Trail
Complete history of all subscription events in `subscriptions` table.

### Flexible Access Control
- Require any subscription
- Require specific tier(s)
- Allow free users with limited features
- Different rate limits by tier

## 📊 Monitoring

### Check Subscription Status
```sql
SELECT 
  u.id,
  u.email,
  p.subscription_status,
  p.subscription_tier,
  p.subscription_expires_at
FROM auth_users u
JOIN user_profiles p ON u.id = p.user_id
WHERE p.subscription_status != 'free';
```

### View Recent Subscription Events
```sql
SELECT 
  u.email,
  s.event_type,
  s.subscription_status,
  s.expires_at,
  s.created_at
FROM subscriptions s
JOIN auth_users u ON s.user_id = u.id
ORDER BY s.created_at DESC
LIMIT 50;
```

### Get Subscription Stats
```sql
SELECT 
  subscription_status,
  subscription_tier,
  COUNT(*) as count
FROM user_profiles
GROUP BY subscription_status, subscription_tier;
```

## 🧪 Testing

### Test Webhook Locally
```bash
curl -X POST http://localhost:3000/api/webhooks/revenuecat \
  -H "Content-Type: application/json" \
  -d '{
    "event": {
      "type": "INITIAL_PURCHASE",
      "app_user_id": "123",
      "product_id": "premium_monthly",
      "store": "APP_STORE",
      "purchased_at_ms": 1234567890000,
      "expiration_at_ms": 1234567890000,
      "environment": "SANDBOX"
    }
  }'
```

### Test Subscription Verification
```javascript
// In any API route
import { requireSubscription } from "@/app/api/utils/subscription-middleware";

export async function GET(request) {
  try {
    const { userId, profile } = await requireSubscription(request);
    return Response.json({ success: true, tier: profile.subscription_tier });
  } catch (error) {
    // Will return 403 if no subscription
    return error;
  }
}
```

### Manually Set Subscription (for testing)
```sql
-- Give user premium subscription
UPDATE user_profiles
SET 
  subscription_status = 'active',
  subscription_tier = 'premium',
  subscription_expires_at = NOW() + INTERVAL '1 month'
WHERE user_id = 123;
```

## 📝 Next Steps

1. **Configure RevenueCat webhook** - This is critical for everything to work
2. **Update product ID mapping** - Match your actual RevenueCat product IDs
3. **Update mobile app** - Pass user ID to `initiate(userId)`
4. **Add subscription checks to premium routes** - Protect your paid features
5. **Test thoroughly** - Verify free users can't access premium features
6. **Add webhook security** - Add authorization header verification (optional but recommended)

## 🚨 Important Notes

### User ID Must Match
The `app_user_id` in RevenueCat MUST equal your `auth_users.id`. This is set by calling `Purchases.logIn(userId)` in the mobile app.

### Webhook is Critical
Without the webhook, subscription status won't sync automatically. Users would need to manually sync or restart the app.

### Existing Users
Existing user profiles will have `subscription_status = 'free'` by default. When they purchase a subscription, the webhook will update their status.

### Sandbox vs Production
The webhook receives an `environment` field indicating if it's a sandbox purchase. Use this for testing.

## 📚 Documentation

- Webhook setup: `/apps/web/src/app/api/webhooks/revenuecat/README.md`
- Middleware usage: `/apps/web/src/app/api/utils/SUBSCRIPTION_MIDDLEWARE_GUIDE.md`
- RevenueCat docs: https://www.revenuecat.com/docs/webhooks

## 🐛 Troubleshooting

### Webhook not receiving events
- Check RevenueCat dashboard for delivery logs
- Verify URL is publicly accessible (not localhost)
- Check server logs for errors

### Subscription not syncing
- Verify user ID is set in RevenueCat: `Purchases.logIn(userId)`
- Check webhook is configured correctly
- Run sync endpoint manually: `POST /api/subscription/sync`

### 403 errors even with subscription
- Check `subscription_expires_at` hasn't passed
- Verify `subscription_status` is 'active' or 'cancelled' (not 'expired')
- Run sync to refresh status

## 💰 Business Logic

### Cancellation Flow
When user cancels, subscription remains `active` until `expires_at`. Then webhook sends EXPIRATION event and status becomes `expired`.

### Billing Issues
If payment fails, status becomes `billing_issue` and user loses access until payment succeeds.

### Grace Period
RevenueCat provides `grace_period_expires_at` for App Store subscriptions in grace period.

### Product Changes
When user upgrades/downgrades, webhook sends PRODUCT_CHANGE event with new tier.
