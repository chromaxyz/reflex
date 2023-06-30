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
      "id": 27674,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27673,
        "name": "onlyOwner",
        "nameLocations": [
          "1086:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28091,
        "src": "1086:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1086:9:23"
    },
    {
      "id": 27676,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27675,
        "name": "nonReentrant",
        "nameLocations": [
          "1096:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27065,
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
      "id": 27706,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27705,
        "name": "nonReentrant",
        "nameLocations": [
          "1404:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27065,
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
      "id": 27749,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27748,
        "name": "onlyOwner",
        "nameLocations": [
          "1868:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28091,
        "src": "1868:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "1868:9:23"
    },
    {
      "id": 27751,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27750,
        "name": "nonReentrant",
        "nameLocations": [
          "1878:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27065,
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
      "id": 27790,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27789,
        "name": "onlyOwner",
        "nameLocations": [
          "2278:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28091,
        "src": "2278:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "2278:9:23"
    },
    {
      "id": 27792,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27791,
        "name": "nonReentrant",
        "nameLocations": [
          "2288:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27065,
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
      "id": 27889,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27888,
        "name": "onlyOwner",
        "nameLocations": [
          "3621:9:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 28091,
        "src": "3621:9:23"
      },
      "nodeType": "ModifierInvocation",
      "src": "3621:9:23"
    },
    {
      "id": 27891,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 27890,
        "name": "nonReentrant",
        "nameLocations": [
          "3631:12:23"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27065,
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
      "id": 28590,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28589,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1053:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27039,
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
      "id": 28659,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28658,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "1747:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27039,
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
      "id": 28743,
      "kind": "modifierInvocation",
      "modifierName": {
        "id": 28742,
        "name": "reentrancyAllowed",
        "nameLocations": [
          "2611:17:32"
        ],
        "nodeType": "IdentifierPath",
        "referencedDeclaration": 27039,
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
