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
      "id": 27569,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27568,
        "name": "onlyOwner",
        "nameLocations": [
          "1344:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "1344:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1344:9:23"
    },
    {
      "id": 27571,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27570,
        "name": "nonReentrant",
        "nameLocations": [
          "1354:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1354:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1354:12:23"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 27597,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27596,
        "name": "nonReentrant",
        "nameLocations": [
          "1740:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1740:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1740:12:23"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 27632,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27631,
        "name": "onlyOwner",
        "nameLocations": [
          "2484:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "2484:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2484:9:23"
    },
    {
      "id": 27634,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27633,
        "name": "nonReentrant",
        "nameLocations": [
          "2494:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "2494:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2494:12:23"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 27667,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27666,
        "name": "onlyOwner",
        "nameLocations": [
          "3005:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "3005:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3005:9:23"
    },
    {
      "id": 27669,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27668,
        "name": "nonReentrant",
        "nameLocations": [
          "3015:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "3015:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3015:12:23"
    }
  ]
}
{
  "name": "upgradeModules",
  "modifiers": [
    {
      "id": 27757,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27756,
        "name": "onlyOwner",
        "nameLocations": [
          "4352:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "4352:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4352:9:23"
    },
    {
      "id": 27759,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27758,
        "name": "nonReentrant",
        "nameLocations": [
          "4362:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "4362:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4362:12:23"
    }
  ]
}
```

**ReflexModule**

```json

```

**ReflexEndpoint**

```json
{
  "name": "sentinel",
  "modifiers": []
}
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
      "id": 28402,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28401,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1526:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "1526:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "1526:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallRevert",
  "modifiers": [
    {
      "id": 28463,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28462,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "2408:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "2408:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "2408:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallReturn",
  "modifiers": [
    {
      "id": 28539,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28538,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "3542:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "3542:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "3542:17:32"
    }
  ]
}
```

**MockImplementationDispatcher**

```json

```
