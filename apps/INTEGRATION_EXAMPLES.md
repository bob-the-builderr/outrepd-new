# Subscription Integration Examples

This document provides real-world examples of how to integrate subscription checks into your OUTREPD app.

## Mobile App Examples

### Example 1: Check Subscription on App Start
```javascript
// /apps/mobile/src/app/index.jsx
import { useEffect } from 'react';
import { useUser } from '@/utils/auth/useUser';
import { authenticatedFetch } from '@/utils/authenticatedFetch';

export default function HomeScreen() {
  const { user } = useUser();
  
  useEffect(() => {
    if (user) {
      checkSubscriptionStatus();
    }
  }, [user]);
  
  async function checkSubscriptionStatus() {
    try {
      const response = await authenticatedFetch('/api/subscription/status');
      const data = await response.json();
      
      if (data.hasActiveSubscription) {
        console.log('User has active subscription:', data.subscription.tier);
      } else {
        console.log('User is on free tier');
      }
    } catch (error) {
      console.error('Failed to check subscription:', error);
    }
  }
  
  return (
    // Your component JSX
  );
}
```

### Example 2: Show Paywall for Premium Feature
```javascript
// /apps/mobile/src/app/(tabs)/train.jsx
import { useState } from 'react';
import { TouchableOpacity, Text } from 'react-native';
import { router } from 'expo-router';
import { authenticatedFetch } from '@/utils/authenticatedFetch';

export default function TrainScreen() {
  const [hasSubscription, setHasSubscription] = useState(null);
  
  async function handlePremiumFeature() {
    try {
      // Check subscription status
      const response = await authenticatedFetch('/api/subscription/status');
      const data = await response.json();
      
      if (data.hasActiveSubscription) {
        // User has subscription, allow access
        router.push('/premium-workout');
      } else {
        // Show paywall
        router.push('/paywall');
      }
    } catch (error) {
      console.error('Failed to check subscription:', error);
      // Show error or paywall
      router.push('/paywall');
    }
  }
  
  return (
    <TouchableOpacity onPress={handlePremiumFeature}>
      <Text>🔒 Premium Workout Plans</Text>
    </TouchableOpacity>
  );
}
```

### Example 3: Conditional UI Based on Subscription
```javascript
// /apps/mobile/src/app/(tabs)/profile.jsx
import { useEffect, useState } from 'react';
import { View, Text } from 'react-native';
import { authenticatedFetch } from '@/utils/authenticatedFetch';

export default function ProfileScreen() {
  const [subscription, setSubscription] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    loadSubscription();
  }, []);
  
  async function loadSubscription() {
    try {
      const response = await authenticatedFetch('/api/subscription/status');
      const data = await response.json();
      setSubscription(data.subscription);
    } catch (error) {
      console.error('Failed to load subscription:', error);
    } finally {
      setLoading(false);
    }
  }
  
  if (loading) {
    return <Text>Loading...</Text>;
  }
  
  return (
    <View>
      {subscription?.tier === 'free' ? (
        <View style={{ backgroundColor: '#333', padding: 16 }}>
          <Text style={{ color: '#FFF' }}>
            🆓 Free Plan - Upgrade to unlock more features!
          </Text>
        </View>
      ) : (
        <View style={{ backgroundColor: '#FFD700', padding: 16 }}>
          <Text style={{ color: '#000' }}>
            ⭐ {subscription.tier.toUpperCase()} Plan Active
          </Text>
          <Text style={{ color: '#666', fontSize: 12 }}>
            Expires: {new Date(subscription.expiresAt).toLocaleDateString()}
          </Text>
        </View>
      )}
      
      {/* Rest of profile UI */}
    </View>
  );
}
```

## Backend API Examples

### Example 1: Protect Match Creation (Premium Only)
```javascript
// /apps/web/src/app/api/matches/invite/route.js
import { requireSubscription } from "@/app/api/utils/subscription-middleware";
import sql from "@/app/api/utils/sql";

export async function POST(request) {
  // Only premium users can create private match invites
  const { userId, profile } = await requireSubscription(request);
  
  const body = await request.json();
  const { muscleGroup } = body;
  
  // Generate invite code
  const inviteCode = generateInviteCode();
  
  // Create match
  await sql`
    INSERT INTO pending_matches (invite_code, host_user_id, muscle_group)
    VALUES (${inviteCode}, ${userId}, ${muscleGroup})
  `;
  
  return Response.json({ 
    success: true, 
    inviteCode,
    tier: profile.subscription_tier 
  });
}
```

### Example 2: Rate Limiting by Tier
```javascript
// /apps/web/src/app/api/matches/route.js
import { checkSubscription } from "@/app/api/utils/subscription-middleware";
import sql from "@/app/api/utils/sql";

export async function POST(request) {
  const { userId, profile, hasActiveSubscription } = await checkSubscription(request);
  
  if (!userId) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }
  
  // Define match limits by tier
  const matchLimits = {
    free: 3,       // 3 matches per day
    premium: 20,   // 20 matches per day
    elite: 999     // Unlimited
  };
  
  const tier = profile?.subscription_tier || 'free';
  const limit = matchLimits[tier];
  
  // Check today's matches
  const todayMatches = await sql`
    SELECT COUNT(*) as count
    FROM matches
    WHERE user_id = ${userId}
    AND match_date > CURRENT_DATE
  `.then(rows => parseInt(rows[0].count));
  
  if (todayMatches >= limit) {
    return Response.json({ 
      error: 'Daily match limit reached',
      limit,
      used: todayMatches,
      tier,
      upgradeRequired: tier === 'free'
    }, { status: 429 });
  }
  
  // Create match
  // ... match creation logic ...
  
  return Response.json({ 
    success: true,
    remaining: limit - todayMatches - 1
  });
}
```

### Example 3: Tiered Features
```javascript
// /apps/web/src/app/api/stats/route.js
import { checkSubscription } from "@/app/api/utils/subscription-middleware";
import sql from "@/app/api/utils/sql";

export async function GET(request) {
  const { userId, hasActiveSubscription } = await checkSubscription(request);
  
  if (!userId) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }
  
  // Basic stats (available to all users)
  const basicStats = await sql`
    SELECT 
      total_matches,
      wins,
      losses,
      current_win_streak
    FROM user_profiles
    WHERE user_id = ${userId}
  `.then(rows => rows[0]);
  
  // Premium stats (only for subscribers)
  let premiumStats = null;
  if (hasActiveSubscription) {
    premiumStats = await sql`
      SELECT 
        muscle_group,
        COUNT(*) as matches,
        SUM(CASE WHEN result = 'win' THEN 1 ELSE 0 END) as wins,
        AVG(user_volume_kg) as avg_volume
      FROM matches
      WHERE user_id = ${userId}
      GROUP BY muscle_group
    `;
  }
  
  return Response.json({
    basic: basicStats,
    premium: premiumStats,
    isPremium: hasActiveSubscription
  });
}
```

### Example 4: Elite-Only Feature
```javascript
// /apps/web/src/app/api/leaderboards/global/route.js
import { requireSubscription } from "@/app/api/utils/subscription-middleware";
import sql from "@/app/api/utils/sql";

export async function GET(request) {
  // Global leaderboard only for elite tier
  const { userId } = await requireSubscription(request, {
    allowedTiers: ['elite']
  });
  
  const leaderboard = await sql`
    SELECT 
      u.name,
      p.username,
      p.tier_idx,
      p.div_idx,
      p.lp,
      p.wins,
      p.losses
    FROM user_profiles p
    JOIN auth_users u ON p.user_id = u.id
    ORDER BY p.tier_idx DESC, p.div_idx DESC, p.lp DESC
    LIMIT 100
  `;
  
  return Response.json({ leaderboard });
}
```

## Testing Scenarios

### Test 1: Free User Accessing Premium Route
```javascript
// User is not subscribed
// Request: POST /api/matches/invite

// Expected Response: 403
{
  "error": "Subscription required",
  "message": "This feature requires an active subscription",
  "subscriptionStatus": "free",
  "tier": "free"
}
```

### Test 2: Premium User Accessing Elite Feature
```javascript
// User has premium subscription
// Request: GET /api/leaderboards/global

// Expected Response: 403
{
  "error": "Insufficient subscription tier",
  "message": "This feature requires elite subscription",
  "currentTier": "premium",
  "requiredTiers": ["elite"]
}
```

### Test 3: Subscription Expiration
```javascript
// User's subscription expired yesterday
// Request: POST /api/matches/invite

// Expected Response: 403
{
  "error": "Subscription required",
  "message": "This feature requires an active subscription",
  "subscriptionStatus": "expired",
  "tier": "free"
}
```

## Common Patterns

### Pattern 1: Graceful Degradation
```javascript
// Allow both free and premium, but with different limits
const { hasActiveSubscription } = await checkSubscription(request);
const limit = hasActiveSubscription ? 100 : 10;
```

### Pattern 2: Hard Paywall
```javascript
// Require subscription, no free access
const { userId } = await requireSubscription(request);
```

### Pattern 3: Tiered Access
```javascript
// Different tiers get different features
const { profile } = await requireSubscription(request);
const features = getTierFeatures(profile.subscription_tier);
```

### Pattern 4: Feature Upsell
```javascript
// Show premium features but lock them
if (!hasActiveSubscription) {
  return Response.json({ 
    features: ['basic'],
    lockedFeatures: ['advanced', 'pro'],
    upgradeRequired: true
  });
}
```

## Mobile App Patterns

### Pattern 1: Lock UI Element
```javascript
const [hasSubscription, setHasSubscription] = useState(false);

// Check on mount
useEffect(() => {
  checkSubscription();
}, []);

// Render with lock icon
<TouchableOpacity 
  onPress={hasSubscription ? handleAction : showPaywall}
>
  {!hasSubscription && <Text>🔒</Text>}
  <Text>Premium Feature</Text>
</TouchableOpacity>
```

### Pattern 2: Show Upgrade Banner
```javascript
const [tier, setTier] = useState('free');

return (
  <View>
    {tier === 'free' && (
      <TouchableOpacity onPress={() => router.push('/paywall')}>
        <View style={styles.upgradeBanner}>
          <Text>⚡ Upgrade to Premium for unlimited matches!</Text>
        </View>
      </TouchableOpacity>
    )}
    {/* Rest of UI */}
  </View>
);
```

### Pattern 3: Conditional Rendering
```javascript
const [isPremium, setIsPremium] = useState(false);

return (
  <View>
    <BasicFeature />
    {isPremium && <PremiumFeature />}
    {isPremium && <AdvancedStats />}
  </View>
);
```

## Important Notes

1. **Always verify server-side** - Client-side checks are for UX only
2. **Handle errors gracefully** - Show user-friendly messages
3. **Cache subscription status** - Don't check on every action
4. **Sync after purchase** - Backend automatically syncs via webhook
5. **Test with expired subscriptions** - Ensure proper handling
6. **Monitor webhook delivery** - Check RevenueCat dashboard
7. **Use clear error messages** - Help users understand what they need

## Deployment Checklist

- [ ] RevenueCat webhook configured and tested
- [ ] Product ID mapping updated in webhook handler
- [ ] Mobile app passes user ID to IAP initialization
- [ ] Premium routes protected with `requireSubscription()`
- [ ] Freemium routes use `checkSubscription()`
- [ ] Error handling tested (expired, billing issues)
- [ ] Mobile app shows subscription status
- [ ] Paywall implemented and linked
- [ ] Rate limits configured by tier
- [ ] Monitoring and logging set up
