# FoxChat V1

---

# Packets

Version Identifier: 1

For your convenience, all packages are formatted in JSON. This also uses websockets!

## Packet Structure
```json
{
    "packet": 0,
    "sentAt": ... // current timestamp in ms
    "data": {
        ...
    }
}
```

## Packet IDs

C->S = Client to Server
S->C = Server to Client
X = Client to Server & Server to Client
A = To aliens

0 = Server Ping (C->S)
1 = Server Ping Response (S->C)
2 = Authenticate (C->S)
3 = Authentication Error (S->C)
4 = Create Account Confirmation (S->C)
5 = Authentication Success (S->C)
6 = Fetch Channels (C->S)
7 = Channels List Response (S->C)

## Pinging

### Request

Body:
- `version`: The FoxChat version the client is based on

### Response

- `version`: The FoxChat version the server is based on
- `name`: The server name
- `color`: The servers primary color, in decimal format

## Login Process

### Authenticate

Body:
- `username`: The username of the user
- `password`: The password of the user
- `register`: A boolean value to determine if this is an attempt to create a user or login. This should be set to false, and then should be resent as true if the user clicks yes on the create account confirmation.
### Authentication Error

Body:
- `message`: The authentication error message

### Create Account Confirmation

Body:
- `username`: The username of the user the user is trying to create

### Authentication Success

*This should also create a session for the specific client on the server.*

Body:
- `token`: The token for the user. Token format can be determined by the server.

## Channels

### Fetch Channels

Body:
- `token`: Optional argument if you want to fetch channels as another user

### Channels list

Body:
- `channels`: A list of channels

# Data structures

## Channel Types

0 = Text

## Channel Visibility

0 = Server Channel
1 = Group DM
2 = Private DM

## Channel

```json
{
    type: 0,
    name: "Example Channel",
    id: <unique id for channel>,
    type: ChannelVisibility
    group: {
        members: [ListOfUserIDs]
    },
    private: {
        users: [ListOfUserIDs]
    },
    server: {
        
    }
}
```