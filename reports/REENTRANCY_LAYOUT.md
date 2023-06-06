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
      "id": 27595,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27594,
        "name": "onlyOwner",
        "nameLocations": [
          "1338:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27978,
        "src": "1338:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1338:9:23"
    },
    {
      "id": 27597,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27596,
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
      "id": 27623,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27622,
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
      "id": 27658,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27657,
        "name": "onlyOwner",
        "nameLocations": [
          "2474:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27978,
        "src": "2474:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2474:9:23"
    },
    {
      "id": 27660,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27659,
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
      "id": 27693,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27692,
        "name": "onlyOwner",
        "nameLocations": [
          "2993:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27978,
        "src": "2993:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2993:9:23"
    },
    {
      "id": 27695,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27694,
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
      "id": 27788,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27787,
        "name": "onlyOwner",
        "nameLocations": [
          "4453:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27978,
        "src": "4453:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "4453:9:23"
    },
    {
      "id": 27790,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27789,
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
      "id": 28464,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28463,
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
      "id": 28533,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28532,
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
      "id": 28617,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28616,
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
