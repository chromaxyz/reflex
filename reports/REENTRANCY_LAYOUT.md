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
      "id": 27636,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27635,
        "name": "onlyOwner",
        "nameLocations": [
          "1086:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28053,
        "src": "1086:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1086:9:23"
    },
    {
      "id": 27638,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27637,
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
      "id": 27668,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27667,
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
      "id": 27711,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27710,
        "name": "onlyOwner",
        "nameLocations": [
          "1868:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28053,
        "src": "1868:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1868:9:23"
    },
    {
      "id": 27713,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27712,
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
      "id": 27752,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27751,
        "name": "onlyOwner",
        "nameLocations": [
          "2278:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28053,
        "src": "2278:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2278:9:23"
    },
    {
      "id": 27754,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27753,
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
      "id": 27851,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27850,
        "name": "onlyOwner",
        "nameLocations": [
          "3621:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28053,
        "src": "3621:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3621:9:23"
    },
    {
      "id": 27853,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27852,
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
      "id": 28548,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28547,
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
      "id": 28617,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28616,
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
      "id": 28701,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28700,
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
{
  "name": "setImplementationState0",
  "modifiers": []
}
```
