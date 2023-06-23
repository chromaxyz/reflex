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
      "id": 27610,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27609,
        "name": "onlyOwner",
        "nameLocations": [
          "1086:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28027,
        "src": "1086:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1086:9:23"
    },
    {
      "id": 27612,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27611,
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
      "id": 27642,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27641,
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
      "id": 27685,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27684,
        "name": "onlyOwner",
        "nameLocations": [
          "1868:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28027,
        "src": "1868:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1868:9:23"
    },
    {
      "id": 27687,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27686,
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
      "id": 27726,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27725,
        "name": "onlyOwner",
        "nameLocations": [
          "2278:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28027,
        "src": "2278:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2278:9:23"
    },
    {
      "id": 27728,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27727,
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
      "id": 27825,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27824,
        "name": "onlyOwner",
        "nameLocations": [
          "3621:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28027,
        "src": "3621:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3621:9:23"
    },
    {
      "id": 27827,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27826,
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
      "id": 28513,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28512,
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
      "id": 28582,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28581,
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
      "id": 28666,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28665,
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
