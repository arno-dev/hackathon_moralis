# Hackathon Moralis x Filecoin

A Flutter project allowing user to send secured media files to each other.



The credentials are ***intentionally*** exposed for the sake of the hackathon. After the judge period is passed, we will removed the app from the Appstore Connect (push notification), Moralis (dApp) and Firebase (messaging / push notifications).

❌ Please Don't do this

✅ Move everything in .env if you want to fork this project .

## Cloudmet

The project is separated in :
- Flutter app
- Nodejs backend application

Below the app flow explained

❌ INSERT AN IMAGE ❌ 

## ✅ Features

Usecase 1 : user can create a wallet based on BIP39 mnemonic and generate a private key and derivate a publickey.

Usecase 2 : user can import a private key (ex: from Metamask)

Usecase 3 : user can pick files, encrypt and send to a recipient public address

Usecase 4 : user can enter the recipient public address through QR Code or copy from clipboard

Usecase 5 : receiver can get the shared link through alert and push notification

Usecase 6 : receiver can see content of the shared link

Usecase 7 : user can see content of links shared to himself

## ❌ Technical constraints
Because we decided to focus on mobile and not web, there's lot of feature provided by Moralis (ex: Authentication) which we could not used in Flutter. 

We checked WalletConnect and MagicLink but it seems (and it makes sense) that after authentication is successful, you can't access to private key. 

As our encryption is based all around symetric encryption from user A to user B, and we send files to user B public address, it's mandatory to find a way to access private key used to derivate the public address. We decided to go to a standard onboarding for wallet creation which is not great UX wise.

## ⬆️ Improvement
Originally the backend was first written with JSON DB to test our MVP quickly, but we migrated the business logic part to OrbitDB. We left token / address storage into JSON DB as storing tokens from Firebase (Web2) on a P2P DB didn't make sense for us at that time. Could be improved by moving it to a P2P DB as well.

The code is using a CLEAN architecture and has been reviewed but as of time constraint, there are things left to be improved such as adding unit testing and maybe optimizing the files which are sent (compress + encrypt it ?).

## Backend
### Prerequisite
The backend is written in Nodejs + Express, Moralis for saving IPFS files, using OrbitDB and JSON DB for database and Firebase Messaging for push notifications. 

Check the node version
```bash
node -v
v15.14.0
```

### Run the backend

Install the dependencies
```bash
  npm install
```

Run the server 
```bash
  npm run start
```

When you see `LOG:: Orbit DB init done` in the console log it means that the API is ready to be called.

## Frontend
### Prerequisite

```bash
flutter doctor -v
[✓] Flutter (Channel stable, 3.3.2, on macOS 12.1 21C52 darwin-arm, locale en-LA)
    • Flutter version 3.3.2 on channel stable at /Users/aphommasone/Documents/dev/flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision e3c29ec00c (6 days ago), 2022-09-14 08:46:55 -0500
    • Engine revision a4ff2c53d8
    • Dart version 2.18.1
    • DevTools version 2.15.0

[✓] Android toolchain - develop for Android devices (Android SDK version 32.1.0-rc1)
    • Android SDK at /Users/aphommasone/Library/Android/sdk
    • Platform android-33, build-tools 32.1.0-rc1
    • Java binary at: /Applications/Android Studio.app/Contents/jre/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.11+0-b60-7772763)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 13.2.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 13C100
    • CocoaPods version 1.11.2

[✓] Android Studio (version 2021.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.11+0-b60-7772763)
```

Installing dependencies and generate files
```bash
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
```

## API 

### Save Images and Share to a eth public address

#### Request
`
curl --request POST \
  --url http://localhost:3000/v2/share/images \
  --header 'Content-Type: application/json' \
  --data '{
   "images":[
      {
         "path":"comet/comet/test_logo.jpg",
         "content":"iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3"
      },
      {
         "path":"comet/test_logo1.jpg",
         "content":"iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3"
      }
   ],
   "origin":"0x71C7656EC7ab88b098defB751B7401B5f6d898B4",
   "dest":"0x71C7656EC7ab88b098defB751B7401B5f6d898B5",
   "encryptIpfsKey":"ElrGGGGYnh"
}	'
`

- `images` : is an array of the uploaded images, constitued of a file path and a content encrypted from frontend
- `origin` : the sender 
- `dest` : the receiver of the sent content
- `encryptIpfsKey` : an encryption key attached by the sender, which ***only*** the receiver can use it to decypher the content in `images`

#### Response
```json
{
	"origin": "0x71C7656EC7ab88b098defB751B7401B5f6d898B4",
	"dest": "0x71C7656EC7ab88b098defB751B7401B5f6d898B5",
	"ipfsKey": "ElrGGGGYnh",
	"cid": "QmQ3tr2fMU5tqsNtq6GyUAB6a1t6yc21h2bHydPCdymD1W",
	"link": "x1fuGsovFgB3IUTJ6pdmh",
	"createdAt": "2022-09-16T17:58:22.413Z"
}
```

- `cid` : the IPFS CID
- `link` : to be used by the receiver

### Retrive information from a shared link

### Request
`curl --request GET \
  --url http://localhost:3000/v2/images/link/-Dmc_2JhPl5ebXyV0F4qk \
  --header 'Content-Type: application/json'`

- `-Dmc_2JhPl5ebXyV0F4qk` : the share link ID

### Response
```json
{
	"ipfsKey": "ElrGGGGYnh",
	"origin": "0x71C7656EC7ab88b098defB751B7401B5f6d898B4",
	"dest": "0x71C7656EC7ab88b098defB751B7401B5f6d898B5",
	"cid": "QmQ3tr2fMU5tqsNtq6GyUAB6a1t6yc21h2bHydPCdymD1W",
	"filetree": {
		"isFolder": true,
		"name": "/",
		"children": [
			{
				"isFolder": true,
				"name": "comet",
				"children": [
					{
						"isFolder": true,
						"name": "comet",
						"children": [
							{
								"isFolder": false,
								"name": "test_logo.jpg"
							}
						]
					},
					{
						"isFolder": false,
						"name": "test_logo1.jpg"
					}
				]
			}
		]
	}
}
```

- `filetree` : will return all the images associated to the IPFS CID `QmQ3tr2fMU5tqsNtq6GyUAB6a1t6yc21h2bHydPCdymD1W` sent by address `0x71C7656EC7ab88b098defB751B7401B5f6d898B4` to receiver `0x71C7656EC7ab88b098defB751B7401B5f6d898B5`. The filetree is a list of folder / files, which folder can contain 0 to n files.

### Get Images from links shared for me
#### Request

`curl --request GET \
  --url http://localhost:3000/v2/share/recents/0x71C7656EC7ab88b098defB751B7401B5f6d898B5 \
  --header 'Content-Type: application/json'`
- `0x71C7656EC7ab88b098defB751B7401B5f6d898B5` : the address of the receiver, which is ourself. 

This API call is used to build the home screen in the Flutter mobile application.

#### Response

```json
[
	{
		"ipfsKey": "ElrGGGGYnh",
		"origin": "0x71C7656EC7ab88b098defB751B7401B5f6d898B4",
		"dest": "0x71C7656EC7ab88b098defB751B7401B5f6d898B5",
		"cid": "QmQ3tr2fMU5tqsNtq6GyUAB6a1t6yc21h2bHydPCdymD1W",
		"createdAt": "2022-09-16T18:03:33.697Z",
		"filetree": {
			"isFolder": true,
			"name": "/",
			"children": [
				{
					"isFolder": true,
					"name": "comet",
					"children": [
						{
							"isFolder": true,
							"name": "comet",
							"children": [
								{
									"isFolder": false,
									"name": "test_logo.jpg"
								}
							]
						},
						{
							"isFolder": false,
							"name": "test_logo1.jpg"
						}
					]
				}
			]
		}
	},
	{
		"ipfsKey": "ElrGGGGYnh",
		"origin": "0x71C7656EC7ab88b098defB751B7401B5f6d898B4",
		"dest": "0x71C7656EC7ab88b098defB751B7401B5f6d898B5",
		"cid": "QmQ3tr2fMU5tqsNtq6GyUAB6a1t6yc21h2bHydPCdymD1W",
		"createdAt": "2022-09-16T18:03:33.697Z",
		"filetree": {
			"isFolder": true,
			"name": "/",
			"children": [
				{
					"isFolder": true,
					"name": "comet",
					"children": [
						{
							"isFolder": true,
							"name": "comet",
							"children": [
								{
									"isFolder": false,
									"name": "test_logo.jpg"
								}
							]
						},
						{
							"isFolder": false,
							"name": "test_logo1.jpg"
						}
					]
				}
			]
		}
	},
	{
		"ipfsKey": "ElrGGGGYnh",
		"origin": "0x71C7656EC7ab88b098defB751B7401B5f6d898B4",
		"dest": "0x71C7656EC7ab88b098defB751B7401B5f6d898B5",
		"cid": "QmQ3tr2fMU5tqsNtq6GyUAB6a1t6yc21h2bHydPCdymD1W",
		"createdAt": "2022-09-16T18:03:33.697Z",
		"filetree": {
			"isFolder": true,
			"name": "/",
			"children": [
				{
					"isFolder": true,
					"name": "comet",
					"children": [
						{
							"isFolder": true,
							"name": "comet",
							"children": [
								{
									"isFolder": false,
									"name": "test_logo.jpg"
								}
							]
						},
						{
							"isFolder": false,
							"name": "test_logo1.jpg"
						}
					]
				}
			]
		}
	}
]
```

### Get the notifications associated to a public address

#### Request 

`curl --request GET \
  --url http://localhost:3000/v2/alerts/0x71C7656EC7ab88b098defB751B7401B5f6d898B5 \
  --header 'Content-Type: application/json'`

- `0x71C7656EC7ab88b098defB751B7401B5f6d898B5` : our public address to get notification addressed to me. Even if an another user is trying to grab the alerts, he won't be able to decypher

#### Response

```json
[
	{
		"message": "0x71C7656E[...] shared with you a link LrFEPn-NC0[...] for accessing : QmQ3tr2fMU[...]",
		"payload": {
			"origin": "0x71C7656EC7ab88b098defB751B7401B5f6d898B4",
			"ipfsKey": "testB4B5_logo",
			"cid": "QmQ3tr2fMU5tqsNtq6GyUAB6a1t6yc21h2bHydPCdymD1W",
			"link": "LrFEPn-NC0w3guizlyIad"
		},
		"date": "2022-09-13T08:49:59.847Z"
	}
]
```


## Contributors 
Arnaud Phommasone ([Arnaud](mailto:arnaud.phommasone@gmail.com))

Phomsavanh Khamchan ([Seau](mailto:seau@comet.la))

Salong Lin ([Along](mailto:saolong@comet.la))

Phongshili Ailyavong ([Li](mailto:li@comet.la))

Nero Sengtianthr ([Beer](mailto:beer@comet.la))

## Resources

- How to understand IPFS, and specially Kademlia algorithm : [IPFS and Kadmelia algorithm] (https://www.youtube.com/watch?v=w9UObz8o8lY)
- How to use IPFS, privacy and handle sharing among users [Privacy and IPFS](https://medium.com/pinata/ipfs-privacy-711f4b72b2ea)
- Encryption best practice : [IPFS, privacy and encryption](https://docs.ipfs.tech/concepts/privacy-and-encryption/#enhancing-your-privacy)
- Understanding public and private keys : [Stackoverflow](https://stackoverflow.com/questions/9375044/can-we-have-multiple-public-keys-with-a-single-private-key-for-rsa), [Accessing private key from Metamask login](https://stackoverflow.com/questions/66914072/web3-accessing-private-key-in-metamask-wallet), [How to import/export Metamask private](https://www.youtube.com/watch?v=OiyFKhSbX2E), [WalletConnect and public/private keys](https://humanitythree.com/2021/08/06/public-private-key-pairs-wallet-connect-and-web-3-0/)
- [Moralis](https://github.com/orbitdb) 
- [OrbitDB](https://github.com/orbitdb)