**ReflexConstants**

```json

```

**ReflexDispatcher**

```json

```

**ReflexInstaller**

```json
{
  "name": "transferOwnership",
  "modifiers": [
    {
      "id": 312,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 311,
        "name": "onlyOwner",
        "nameLocations": [
          "1086:9:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 698,
        "src": "1086:9:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "1086:9:3"
    },
    {
      "id": 314,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 313,
        "name": "nonReentrant",
        "nameLocations": [
          "1096:12:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 677,
        "src": "1096:12:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "1096:12:3"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 344,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 343,
        "name": "nonReentrant",
        "nameLocations": [
          "1404:12:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 677,
        "src": "1404:12:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "1404:12:3"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 387,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 386,
        "name": "onlyOwner",
        "nameLocations": [
          "1868:9:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 698,
        "src": "1868:9:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "1868:9:3"
    },
    {
      "id": 389,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 388,
        "name": "nonReentrant",
        "nameLocations": [
          "1878:12:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 677,
        "src": "1878:12:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "1878:12:3"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 428,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 427,
        "name": "onlyOwner",
        "nameLocations": [
          "2284:9:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 698,
        "src": "2284:9:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "2284:9:3"
    },
    {
      "id": 430,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 429,
        "name": "nonReentrant",
        "nameLocations": [
          "2294:12:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 677,
        "src": "2294:12:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "2294:12:3"
    }
  ]
}
{
  "name": "upgradeModules",
  "modifiers": [
    {
      "id": 524,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 523,
        "name": "onlyOwner",
        "nameLocations": [
          "3831:9:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 698,
        "src": "3831:9:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "3831:9:3"
    },
    {
      "id": 526,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 525,
        "name": "nonReentrant",
        "nameLocations": [
          "3841:12:3"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 677,
        "src": "3841:12:3"
      },
      "nodeType": "ModifierInvocation",
      "src": "3841:12:3"
    }
  ]
}
```

**ReflexModule**

```json

```

**ReflexEndpoint**

```json

```

**ReflexState**

```json

```

**ReflexBatch**

```json
{
  "name": "performBatchCall",
  "modifiers": [
    {
      "id": 1306,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 1305,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1002:17:11"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 670,
        "src": "1002:17:11"
      },
      "nodeType": "ModifierInvocation",
      "src": "1002:17:11"
    }
  ]
}
{
  "name": "simulateBatchCall",
  "modifiers": [
    {
      "id": 1375,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 1374,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1690:17:11"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 670,
        "src": "1690:17:11"
      },
      "nodeType": "ModifierInvocation",
      "src": "1690:17:11"
    }
  ]
}
```
