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
      "id": 27344,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27343,
        "name": "onlyOwner",
        "nameLocations": [
          "1371:9:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27711,
        "src": "1371:9:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "1371:9:21"
    },
    {
      "id": 27346,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27345,
        "name": "nonReentrant",
        "nameLocations": [
          "1381:12:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "1381:12:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "1381:12:21"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 27373,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27372,
        "name": "nonReentrant",
        "nameLocations": [
          "1776:12:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "1776:12:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "1776:12:21"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 27409,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27408,
        "name": "onlyOwner",
        "nameLocations": [
          "2529:9:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27711,
        "src": "2529:9:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "2529:9:21"
    },
    {
      "id": 27411,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27410,
        "name": "nonReentrant",
        "nameLocations": [
          "2539:12:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "2539:12:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "2539:12:21"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 27445,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27444,
        "name": "onlyOwner",
        "nameLocations": [
          "3059:9:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27711,
        "src": "3059:9:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "3059:9:21"
    },
    {
      "id": 27447,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27446,
        "name": "nonReentrant",
        "nameLocations": [
          "3069:12:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "3069:12:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "3069:12:21"
    }
  ]
}
{
  "name": "upgradeModules",
  "modifiers": [
    {
      "id": 27536,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27535,
        "name": "onlyOwner",
        "nameLocations": [
          "4406:9:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27711,
        "src": "4406:9:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "4406:9:21"
    },
    {
      "id": 27538,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27537,
        "name": "nonReentrant",
        "nameLocations": [
          "4416:12:21"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26925,
        "src": "4416:12:21"
      },
      "nodeType": "ModifierInvocation",
      "src": "4416:12:21"
    }
  ]
}
```

**ReflexModule**

```json

```

**ReflexProxy**

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
      "id": 28283,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28282,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "780:17:31"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26905,
        "src": "780:17:31"
      },
      "nodeType": "ModifierInvocation",
      "src": "780:17:31"
    }
  ]
}
{
  "name": "simulateBatchCall",
  "modifiers": [
    {
      "id": 28340,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28339,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1509:17:31"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 26905,
        "src": "1509:17:31"
      },
      "nodeType": "ModifierInvocation",
      "src": "1509:17:31"
    }
  ]
}
```

**MockImplementationDispatcher**

```json

```
