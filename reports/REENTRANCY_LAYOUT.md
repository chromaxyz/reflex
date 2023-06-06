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
      "id": 27597,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27596,
        "name": "onlyOwner",
        "nameLocations": [
          "1338:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27980,
        "src": "1338:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1338:9:23"
    },
    {
      "id": 27599,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27598,
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
      "id": 27625,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27624,
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
      "id": 27660,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27659,
        "name": "onlyOwner",
        "nameLocations": [
          "2474:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27980,
        "src": "2474:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2474:9:23"
    },
    {
      "id": 27662,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27661,
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
      "id": 27695,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27694,
        "name": "onlyOwner",
        "nameLocations": [
          "2993:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27980,
        "src": "2993:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2993:9:23"
    },
    {
      "id": 27697,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27696,
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
      "id": 27790,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27789,
        "name": "onlyOwner",
        "nameLocations": [
          "4453:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27980,
        "src": "4453:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4453:9:23"
    },
    {
      "id": 27792,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27791,
        "name": "nonReentrant",
        "nameLocations": [
          "4463:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27021,
        "src": "4463:12:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4463:12:23"
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
      "id": 28430,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28429,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1589:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "1589:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "1589:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallRevert",
  "modifiers": [
    {
      "id": 28499,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28498,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "2552:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "2552:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "2552:17:32"
    }
  ]
}
{
  "name": "simulateBatchCallReturn",
  "modifiers": [
    {
      "id": 28583,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28582,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "3767:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27001,
        "src": "3767:17:32"
      },
      "nodeType": "ModifierInvocation",
      "src": "3767:17:32"
    }
  ]
}
```

**MockImplementationDispatcher**

```json

```
