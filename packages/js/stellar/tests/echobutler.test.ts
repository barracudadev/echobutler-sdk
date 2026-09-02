import { describe, expect, it, vi } from 'vitest'
import type { EchoButlerClient } from '@echobutler/core'
import { getTransactionHistory } from '../src/echobutler'

function createMockClient(): EchoButlerClient {
  return {
    request: vi.fn().mockResolvedValue({ transactions: [], cursor: null }),
    config: { network: 'testnet' },
    on: vi.fn(),
    off: vi.fn(),
    emit: vi.fn(),
    setAuthToken: vi.fn(),
  } as unknown as EchoButlerClient
}

describe('getTransactionHistory', () => {
  it('uses the canonical snake_case public_key query parameter', async () => {
    const client = createMockClient()

    await getTransactionHistory(client, 'GALICE', { limit: 10, cursor: 'next' })

    expect(client.request).toHaveBeenCalledWith(
      'GET',
      '/stellar/transactions?public_key=GALICE&limit=10&cursor=next',
    )
  })
})
