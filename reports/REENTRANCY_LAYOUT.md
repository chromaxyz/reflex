**ReflexBase**

```json

```

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
      "id": 27603,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27602,
        "name": "onlyOwner",
        "nameLocations": [
          "1086:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28020,
        "src": "1086:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1086:9:23"
    },
    {
      "id": 27605,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27604,
        "name": "nonReentrant",
        "nameLocations": [
          "1096:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27027,
        "src": "1096:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1096:12:23"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 27635,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27634,
        "name": "nonReentrant",
        "nameLocations": [
          "1404:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27027,
        "src": "1404:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1404:12:23"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 27678,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27677,
        "name": "onlyOwner",
        "nameLocations": [
          "1868:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28020,
        "src": "1868:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1868:9:23"
    },
    {
      "id": 27680,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27679,
        "name": "nonReentrant",
        "nameLocations": [
          "1878:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27027,
        "src": "1878:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1878:12:23"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 27719,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27718,
        "name": "onlyOwner",
        "nameLocations": [
          "2278:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28020,
        "src": "2278:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2278:9:23"
    },
    {
      "id": 27721,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27720,
        "name": "nonReentrant",
        "nameLocations": [
          "2288:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27027,
        "src": "2288:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2288:12:23"
    }
  ]
}
{
  "name": "upgradeModules",
  "modifiers": [
    {
      "id": 27818,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27817,
        "name": "onlyOwner",
        "nameLocations": [
          "3621:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28020,
        "src": "3621:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3621:9:23"
    },
    {
      "id": 27820,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27819,
        "name": "nonReentrant",
        "nameLocations": [
          "3631:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27027,
        "src": "3631:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3631:12:23"
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
      "id": 28502,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28501,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1053:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "1053:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "1053:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallRevert",
  "modifiers": [
    {
      "id": 28571,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28570,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1747:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "1747:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "1747:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallReturn",
  "modifiers": [
    {
      "id": 28655,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28654,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "2611:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "2611:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "2611:17:32"
    }
  ]
}
```

**MockImplementationDispatcher**

```json

```
