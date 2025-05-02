# FoxChat V1

Default Port: 4532

---

# Packets

Version Identifier: 1

For your convenience, all packages are formatted in JSON. This also uses websockets!

## Packet Structure
```json
{
    "type": 0,
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

0 = Server Ping (C->S)
1 = Server Ping Response (S->C)
2 = Authenticate (C->S)
3 = Authentication Error (S->C)
4 = Create Account Confirmation (S->C)
5 = Authentication Success (S->C)
6 = Authenticate By Token (C->S)
7 = Server Form (S->C)
8 = Server Form Response (C->S)
9 = Client Initialize Data (C->S)


## Pinging

### Request

Body:
- `version`: The FoxChat version the client is based on

### Response

- `version`: The FoxChat version the server is based on
- `name`: The server name
- `color`: The servers primary color, in decimal format
- `motd`: A message of the day, if you really want to

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

### Authenticate by Token

Body:
- `token`: The token to login with

## Server Form

### Requesting Packet Structure

```ts
type ButtonControl = {
    type: 0;
    id: string;
    label: string;
    useAccent?: boolean;
}

type TextInputControl = {
    type: 1;
    id: string;
    label: string;
    placeholder: string;
    defaultValue?: string;
    maxChars?: number;
    minChars?: number;
}

type ToggleControl = {
    type: 2;
    id: string;
    defaultValue?: boolean;
}

type Control = ButtonControl | TextInputControl | ToggleControl;

type ServerFormPacket = {
    type: 7;
    data: {
        form: {
            id: string; // unique ID for the form (required, preferably a UUID)
            title?: string;
            body?: string;
            controls: Control[];
        }    
    }
}
```

### Response Structure

```ts
type ServerFormResponsePacket = {
    id: string;
    requestButton: string; // id of button clicked to submit form
    formValues: {
        [id: string]: string | boolean | null
    }
}
```

## General Data Structures

### User Structure

```ts
type User = {
    username: string;
    uuid: string; // the users id. as of FoxChat v1, this isnt required to be an actual uuid but might be in future versions.
    avatarURL: string; // can be url to image, or base64 url if you want.
    bannerURL: string; // can be url to image, or base64 url if you want.
    profileColor: number; // the color of the profile, stored in decimal format (e.g. 0xFFFFFF = 16777215)
    aboutMe: string; // the users about me
    pronouns: string; // the users pronouns
    accountCreatedAt: number; // timestamp of the users creation in MS
    globalRole: number; // 0 = Member (Limited), 1 = Member (Normal), 2 = Member (Lifted), 3 = Basic Moderator, 4 = Moderator, 5 = Admin, 6 = Head Admin, 7 = Manager, 8 = Lead Manager, 9 = Owner
    badges: string[]; // the users badges (badges are server defined)
    bot: boolean; // signifying if the user is a bot or not
}
```