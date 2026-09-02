import React, { createContext, useContext, useEffect, useState, useCallback } from 'react'
import { EchoButlerClient } from '@echobutler/core'
import type { EchoButlerConfig, MoodStreak, UserProfile } from '@echobutler/core'

// ─── Context ──────────────────────────────────────────────────────────────────

interface EchoButlerContextValue {
  client: EchoButlerClient
  profile: UserProfile | null
  isLoading: boolean
  error: Error | null
}

const EchoButlerContext = createContext<EchoButlerContextValue | null>(null)

// ─── Provider ─────────────────────────────────────────────────────────────────

export interface EchoButlerProviderProps {
  apiKey: string
  config?: Omit<EchoButlerConfig, 'apiKey'>
  authToken?: string
  children: React.ReactNode
}

/**
 * Wrap your app with this provider to access all EchoButler hooks.
 *
 * @example
 * <EchoButlerProvider apiKey="your_api_key">
 *   <App />
 * </EchoButlerProvider>
 */
export function EchoButlerProvider({
  apiKey,
  config,
  authToken,
  children,
}: EchoButlerProviderProps) {
  const [client] = useState(
    () => new EchoButlerClient({ apiKey, ...config }),
  )
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<Error | null>(null)

  useEffect(() => {
    if (authToken) {
      client.setAuthToken(authToken)
      setIsLoading(true)
      client
        .request<UserProfile>('GET', '/users/me')
        .then(setProfile)
        .catch(setError)
        .finally(() => setIsLoading(false))
    } else {
      client.setAuthToken(null)
      setProfile(null)
    }
  }, [client, authToken])

  return (
    <EchoButlerContext.Provider value={{ client, profile, isLoading, error }}>
      {children}
    </EchoButlerContext.Provider>
  )
}

// ─── Hooks ────────────────────────────────────────────────────────────────────

function useEchoButler() {
  const ctx = useContext(EchoButlerContext)
  if (!ctx) {
    throw new Error('useEchoButler must be used inside <EchoButlerProvider>')
  }
  return ctx
}

/**
 * Access the raw EchoButlerClient for direct API calls.
 */
export function useEchoButlerClient(): EchoButlerClient {
  return useEchoButler().client
}

/**
 * Get the authenticated user's profile.
 *
 * @example
 * const { profile, isLoading } = useProfile()
 */
export function useProfile() {
  const { profile, isLoading, error } = useEchoButler()
  return { profile, isLoading, error }
}

/**
 * Get and refresh the user's mood streak.
 *
 * @example
 * const { streak, refetch } = useMoodStreak()
 * return <p>{streak?.current} day streak 🔥</p>
 */
export function useMoodStreak() {
  const { client } = useEchoButler()
  const [streak, setStreak] = useState<MoodStreak | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<Error | null>(null)

  const refetch = useCallback(async () => {
    setIsLoading(true)
    try {
      const result = await client.request<MoodStreak>('GET', '/mood/streak')
      setStreak(result)
    } catch (err) {
      setError(err as Error)
    } finally {
      setIsLoading(false)
    }
  }, [client])

  useEffect(() => { refetch() }, [refetch])

  return { streak, isLoading, error, refetch }
}

/**
 * Listen to real-time SDK events.
 *
 * @example
 * useSDKEvent('mood:logged', (event) => {
 *   toast(`Mood logged: ${event.entry.score}/10`)
 * })
 */
export function useSDKEvent<T extends Parameters<typeof EchoButlerClient.prototype.on>[0]>(
  eventType: T,
  handler: Parameters<typeof EchoButlerClient.prototype.on<{ type: T } & Parameters<typeof EchoButlerClient.prototype.emit>[0]>>[1],
) {
  const { client } = useEchoButler()
  useEffect(() => {
    return client.on(eventType as never, handler as never)
  }, [client, eventType, handler])
}
