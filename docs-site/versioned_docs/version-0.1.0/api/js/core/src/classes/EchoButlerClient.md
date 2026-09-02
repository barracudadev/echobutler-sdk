# Class: EchoButlerClient

Defined in: [packages/js/core/src/client.ts:7](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L7)

## Constructors

### Constructor

> **new EchoButlerClient**(`config`): `EchoButlerClient`

Defined in: [packages/js/core/src/client.ts:12](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L12)

#### Parameters

##### config

[`EchoButlerConfig`](../interfaces/EchoButlerConfig.md)

#### Returns

`EchoButlerClient`

## Properties

### config

> `readonly` **config**: `Required`\<[`EchoButlerConfig`](../interfaces/EchoButlerConfig.md)\>

Defined in: [packages/js/core/src/client.ts:8](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L8)

## Methods

### emit()

> **emit**\<`T`\>(`event`): `void`

Defined in: [packages/js/core/src/client.ts:90](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L90)

#### Type Parameters

##### T

`T` *extends* [`SDKEvent`](../type-aliases/SDKEvent.md)

#### Parameters

##### event

`T`

#### Returns

`void`

***

### off()

> **off**\<`T`\>(`eventType`, `handler`): `void`

Defined in: [packages/js/core/src/client.ts:86](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L86)

#### Type Parameters

##### T

`T` *extends* [`SDKEvent`](../type-aliases/SDKEvent.md)

#### Parameters

##### eventType

`T`\[`"type"`\]

##### handler

[`SDKEventHandler`](../type-aliases/SDKEventHandler.md)\<`T`\>

#### Returns

`void`

***

### on()

> **on**\<`T`\>(`eventType`, `handler`): () => `void`

Defined in: [packages/js/core/src/client.ts:78](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L78)

#### Type Parameters

##### T

`T` *extends* [`SDKEvent`](../type-aliases/SDKEvent.md)

#### Parameters

##### eventType

`T`\[`"type"`\]

##### handler

[`SDKEventHandler`](../type-aliases/SDKEventHandler.md)\<`T`\>

#### Returns

() => `void`

***

### request()

> **request**\<`T`\>(`method`, `path`, `body?`): `Promise`\<`T`\>

Defined in: [packages/js/core/src/client.ts:23](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L23)

#### Type Parameters

##### T

`T`

#### Parameters

##### method

`"GET"` \| `"POST"` \| `"PATCH"` \| `"DELETE"`

##### path

`string`

##### body?

`unknown`

#### Returns

`Promise`\<`T`\>

***

### setAuthToken()

> **setAuthToken**(`token`): `void`

Defined in: [packages/js/core/src/client.ts:72](https://github.com/karanjadavi/echobutler-sdk/blob/1e86960804b3b9d6c6107f0f78b2c968a63ffa5f/packages/js/core/src/client.ts#L72)

#### Parameters

##### token

`string` \| `null`

#### Returns

`void`
