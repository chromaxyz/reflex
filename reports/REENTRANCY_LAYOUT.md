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
          "1338:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "1338:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1338:9:23"
    },
    {
      "id": 27571,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27570,
        "name": "nonReentrant",
        "nameLocations": [
          "1348:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1348:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1348:12:23"
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
          "1732:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1732:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1732:12:23"
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
          "2474:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "2474:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2474:9:23"
    },
    {
      "id": 27634,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27633,
        "name": "nonReentrant",
        "nameLocations": [
          "2484:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "2484:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2484:12:23"
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
          "2993:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "2993:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2993:9:23"
    },
    {
      "id": 27669,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27668,
        "name": "nonReentrant",
        "nameLocations": [
          "3003:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "3003:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3003:12:23"
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
          "4338:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "4338:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4338:9:23"
    },
    {
      "id": 27759,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27758,
        "name": "nonReentrant",
        "nameLocations": [
          "4348:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "4348:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4348:12:23"
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
          "1522:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "1522:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "1522:17:32"
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
          "2402:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "2402:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "2402:17:32"
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
          "3534:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "3534:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "3534:17:32"
    }
  ]
}
```

**MockImplementationDispatcher**

```json

```
