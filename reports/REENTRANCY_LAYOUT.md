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
      "id": 27565,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27564,
        "name": "onlyOwner",
        "nameLocations": [
          "1371:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "1371:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1371:9:23"
    },
    {
      "id": 27567,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27566,
        "name": "nonReentrant",
        "nameLocations": [
          "1381:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1381:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1381:12:23"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 27594,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27593,
        "name": "nonReentrant",
        "nameLocations": [
          "1776:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1776:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1776:12:23"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 27630,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27629,
        "name": "onlyOwner",
        "nameLocations": [
          "2529:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "2529:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2529:9:23"
    },
    {
      "id": 27632,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27631,
        "name": "nonReentrant",
        "nameLocations": [
          "2539:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "2539:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2539:12:23"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 27666,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27665,
        "name": "onlyOwner",
        "nameLocations": [
          "3059:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "3059:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3059:9:23"
    },
    {
      "id": 27668,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27667,
        "name": "nonReentrant",
        "nameLocations": [
          "3069:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "3069:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3069:12:23"
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
          "4415:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27932,
        "src": "4415:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4415:9:23"
    },
    {
      "id": 27759,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27758,
        "name": "nonReentrant",
        "nameLocations": [
          "4425:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "4425:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4425:12:23"
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
      "id": 28408,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28407,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1528:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "1528:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "1528:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallRevert",
  "modifiers": [
    {
      "id": 28470,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28469,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "2419:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "2419:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "2419:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallReturn",
  "modifiers": [
    {
      "id": 28547,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28546,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "3562:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "3562:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "3562:17:32"
    }
  ]
}
```

**MockImplementationDispatcher**

```json

```
