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
      "id": 27469,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27468,
        "name": "onlyOwner",
        "nameLocations": [
          "1371:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27836,
        "src": "1371:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1371:9:22"
    },
    {
      "id": 27471,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27470,
        "name": "nonReentrant",
        "nameLocations": [
          "1381:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "1381:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1381:12:22"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 27498,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27497,
        "name": "nonReentrant",
        "nameLocations": [
          "1776:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "1776:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "1776:12:22"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 27534,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27533,
        "name": "onlyOwner",
        "nameLocations": [
          "2529:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27836,
        "src": "2529:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "2529:9:22"
    },
    {
      "id": 27536,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27535,
        "name": "nonReentrant",
        "nameLocations": [
          "2539:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "2539:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "2539:12:22"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 27570,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27569,
        "name": "onlyOwner",
        "nameLocations": [
          "3059:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27836,
        "src": "3059:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "3059:9:22"
    },
    {
      "id": 27572,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27571,
        "name": "nonReentrant",
        "nameLocations": [
          "3069:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "3069:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "3069:12:22"
    }
  ]
}
{
  "name": "upgradeModules",
  "modifiers": [
    {
      "id": 27661,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27660,
        "name": "onlyOwner",
        "nameLocations": [
          "4415:9:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27836,
        "src": "4415:9:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "4415:9:22"
    },
    {
      "id": 27663,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27662,
        "name": "nonReentrant",
        "nameLocations": [
          "4425:12:22"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "4425:12:22"
      },
      "nodeType": "ModifierInvocation",
      "src": "4425:12:22"
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
      "id": 28312,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28311,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1528:17:31"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26905,
        "src": "1528:17:31"
      },
      "nodeType": "ModifierInvocation",
      "src": "1528:17:31"
    }
  ]
}
{
  "name": "simulateBatchCallRevert",
  "modifiers": [
    {
      "id": 28374,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28373,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "2419:17:31"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26905,
        "src": "2419:17:31"
      },
      "nodeType": "ModifierInvocation",
      "src": "2419:17:31"
    }
  ]
}
{
  "name": "simulateBatchCallReturn",
  "modifiers": [
    {
      "id": 28451,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28450,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "3580:17:31"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26905,
        "src": "3580:17:31"
      },
      "nodeType": "ModifierInvocation",
      "src": "3580:17:31"
    }
  ]
}
```

**MockImplementationDispatcher**

```json

```
