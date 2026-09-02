---
sidebar_position: 2
---

# React Quickstart

## Install

```bash
npm install @echobutler/react @echobutler/core
```

## Wrap your app in the provider

```tsx
import { EchoButlerProvider } from '@echobutler/react'

function App() {
  return (
    <EchoButlerProvider apiKey={process.env.REACT_APP_ECHOBUTLER_API_KEY}>
      <MoodDashboard />
    </EchoButlerProvider>
  )
}
```

## Use the mood hook

```tsx
import { useEchoButler } from '@echobutler/react'

function MoodDashboard() {
  const { client, profile, isLoading, error } = useEchoButler()

  if (isLoading) return <p>Loading...</p>
  if (error) return <p>Something went wrong: {error.message}</p>

  return (
    <div>
      <h2>Welcome back, {profile?.displayName}</h2>
      <p>Current streak: {profile?.moodStreak} days</p>
    </div>
  )
}
```

## Next steps

- [Core Concepts](../core-concepts) to understand how the pieces fit together
- [Architecture and package guide](../architecture) for the full typed API surface, including `EchoButlerConfig`, `MoodStreak`, and `UserProfile`
