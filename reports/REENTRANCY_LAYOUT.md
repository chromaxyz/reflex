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
      "id": 27593,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27592,
        "name": "onlyOwner",
        "nameLocations": [
          "1052:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27976,
        "src": "1052:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1052:9:23"
    },
    {
      "id": 27595,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27594,
        "name": "nonReentrant",
        "nameLocations": [
          "1062:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1062:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1062:12:23"
    }
  ]
}
{
  "name": "acceptOwnership",
  "modifiers": [
    {
      "id": 27621,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27620,
        "name": "nonReentrant",
        "nameLocations": [
          "1336:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1336:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1336:12:23"
    }
  ]
}
{
  "name": "renounceOwnership",
  "modifiers": [
    {
      "id": 27656,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27655,
        "name": "onlyOwner",
        "nameLocations": [
          "1732:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27976,
        "src": "1732:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1732:9:23"
    },
    {
      "id": 27658,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27657,
        "name": "nonReentrant",
        "nameLocations": [
          "1742:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "1742:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1742:12:23"
    }
  ]
}
{
  "name": "addModules",
  "modifiers": [
    {
      "id": 27691,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27690,
        "name": "onlyOwner",
        "nameLocations": [
          "2091:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27976,
        "src": "2091:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2091:9:23"
    },
    {
      "id": 27693,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27692,
        "name": "nonReentrant",
        "nameLocations": [
          "2101:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "2101:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2101:12:23"
    }
  ]
}
{
  "name": "upgradeModules",
  "modifiers": [
    {
      "id": 27786,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27785,
        "name": "onlyOwner",
        "nameLocations": [
          "3384:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27976,
        "src": "3384:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3384:9:23"
    },
    {
      "id": 27788,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27787,
        "name": "nonReentrant",
        "nameLocations": [
          "3394:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "3394:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3394:12:23"
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
      "id": 28463,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28462,
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
      "id": 28532,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28531,
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
      "id": 28616,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28615,
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
