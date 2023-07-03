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
      "id": 27420,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27419,
        "name": "onlyOwner",
        "nameLocations": [
          "1086:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27881,
        "src": "1086:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1086:9:22"
    },
    {
      "id": 27422,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27421,
        "name": "nonReentrant",
        "nameLocations": [
          "1096:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27855,
        "src": "1096:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1096:12:22"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 27452,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27451,
        "name": "nonReentrant",
        "nameLocations": [
          "1404:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27855,
        "src": "1404:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1404:12:22"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 27495,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27494,
        "name": "onlyOwner",
        "nameLocations": [
          "1868:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27881,
        "src": "1868:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1868:9:22"
    },
    {
      "id": 27497,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27496,
        "name": "nonReentrant",
        "nameLocations": [
          "1878:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27855,
        "src": "1878:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1878:12:22"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 27536,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27535,
        "name": "onlyOwner",
        "nameLocations": [
          "2278:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27881,
        "src": "2278:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "2278:9:22"
    },
    {
      "id": 27538,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27537,
        "name": "nonReentrant",
        "nameLocations": [
          "2288:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27855,
        "src": "2288:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "2288:12:22"
    }
  ]
}
{
  "name": "upgradeModules",
  "modifiers": [
    {
      "id": 27635,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27634,
        "name": "onlyOwner",
        "nameLocations": [
          "3621:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27881,
        "src": "3621:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "3621:9:22"
    },
    {
      "id": 27637,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27636,
        "name": "nonReentrant",
        "nameLocations": [
          "3631:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27855,
        "src": "3631:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "3631:12:22"
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
      "id": 28587,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28586,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1053:17:30"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27829,
        "src": "1053:17:30"
      },
      "nodeType": "ModifierInvocation",
      "src": "1053:17:30"
    }
  ]
}
{
  "name": "simulateBatchCallRevert",
  "modifiers": [
    {
      "id": 28656,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28655,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1747:17:30"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27829,
        "src": "1747:17:30"
      },
      "nodeType": "ModifierInvocation",
      "src": "1747:17:30"
    }
  ]
}
{
  "name": "simulateBatchCallReturn",
  "modifiers": [
    {
      "id": 28740,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28739,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "2611:17:30"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27829,
        "src": "2611:17:30"
      },
      "nodeType": "ModifierInvocation",
      "src": "2611:17:30"
    }
  ]
}
```
