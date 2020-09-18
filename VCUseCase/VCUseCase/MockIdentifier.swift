/*---------------------------------------------------------------------------------------------
*  Copyright (c) Microsoft Corporation. All rights reserved.
*  Licensed under the MIT License. See License.txt in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import VcJwt
import VcNetworking

struct MockIdentifier {
    let keyId: KeyId = KeyId(id: UUID())
    let id: String = "did:ion:EiAh3uVztIebuoaoKzRXMsNgkFT26Bg-D6NfaJqghVLA_Q?-ion-initial-state=eyJkZWx0YV9oYXNoIjoiRWlBbVQxOHV5YTRZQzFsTEl6cWtaT3M3QTVuRnB1TWp4WWsxYmxDZEluTFlIUSIsInJlY292ZXJ5X2NvbW1pdG1lbnQiOiJFaURwQms4aHJ0WXNlRk1ieWtoOWxtdkpCR2NITDI2WExwN25mYjFlNUM2QlJBIn0.eyJ1cGRhdGVfY29tbWl0bWVudCI6IkVpQWIyUnJjeTQ5cVUzMWZKMGM3a2pYWTV2cXZIbldLaDRiUVZ6MlBFSGdtY2ciLCJwYXRjaGVzIjpbeyJhY3Rpb24iOiJyZXBsYWNlIiwiZG9jdW1lbnQiOnsicHVibGljX2tleXMiOlt7ImlkIjoiQXdNX3NpZ25faW9uXzEiLCJ0eXBlIjoiRWNkc2FTZWNwMjU2azFWZXJpZmljYXRpb25LZXkyMDE5IiwiandrIjp7Imt0eSI6IkVDIiwiY3J2Ijoic2VjcDI1NmsxIiwieCI6IjhKckdoU2JtYk5obWFCdnN5TGFXUWRXNlFHOXJtSU1EQ3p4b2RiRlZ3S0EiLCJ5Ijoiemx6QjFhLUMtYS1MSXIzakFqRkc1M2NJb3YyazlCenBkZmYyVUVUNEY2VSJ9LCJwdXJwb3NlIjpbImF1dGgiLCJnZW5lcmFsIl19XX19XX0"
    let algorithm: String = "ES256K"
}
