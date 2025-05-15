# SimpleStorage Smart Contract

A robust Ethereum smart contract for storing, retrieving, and managing favourite numbers associated with individuals.



## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Contract Architecture](#contract-architecture)
- [Function Documentation](#function-documentation)
- [Real-World Use Cases](#real-world-use-cases)
- [Deployment Guide](#deployment-guide)
- [Security Considerations](#security-considerations)
- [Gas Optimization](#gas-optimization)
- [Contributing](#contributing)
- [License](#license)

## Overview

SimpleStorage is a foundational smart contract that demonstrates core Ethereum development concepts while providing practical utility for data storage on the blockchain. The contract maintains a registry of people and their associated favourite numbers with efficient lookup capabilities.

## Features

- ✅ Store and retrieve individual favourite numbers
- ✅ Register people with their names and favourite numbers
- ✅ Efficient name-based lookups via mapping
- ✅ Access controls for administrative functions
- ✅ Comprehensive event logging for all state changes
- ✅ Input validation to prevent errors
- ✅ Optimised for gas efficiency

## Contract Architecture

### Core Components

#### State Variables

```solidity
uint256 private myFavoriteNumber;
address the public owner;
```

The contract maintains a primary `myFavoriteNumber` value and an owner address for access control.

#### Data Structures

```solidity
struct Person {
    uint256 favoriteNumber;
    string name;
}

Person[] public listOfPeople;
mapping(string => uint256) public nameToFavoriteNumber;
```

The contract uses two complementary data structures:
1. An array (`listOfPeople`) that stores all Person structs sequentially
2. A mapping (`nameToFavoriteNumber`) for efficient name-to-number lookups

#### Events

```solidity
event FavoriteNumberUpdated(uint256 indexed oldValue, uint256 indexed newValue);
event PersonAdded(string indexed name, uint256 favoriteNumber, uint256 listPosition);
```

Events provide transparency and allow off-chain applications to track contract activity.

## Function Documentation

### Core Functions

#### `store(uint256 _favoriteNumber)`

```solidity
function store(uint256 _favoriteNumber) public
```

Stores a new favourite number in the contract's primary variable.
- Emits `FavoriteNumberUpdated` when the value changes
- No access restrictions - any address can call this function

#### `retrieve()`

```solidity
function retrieve() public view returns (uint256)
```

Retrieves the currently stored favourite number.
- Read-only (view) function that doesn't modify state
- Returns the current value of `myFavoriteNumber`

#### `addPerson(string memory _name, uint256 _favoriteNumber)`

```solidity
function addPerson(string memory _name, uint256 _favoriteNumber) public
```

Registers a new person with their name and favourite number.
- Validates that the name is not empty
- Updates both the array and mapping simultaneously
- Emits `PersonAdded` event with the person's details and array position

### Extended Functionality

#### `getPeopleCount()`

```solidity
function getPeopleCount() public view returns (uint256)
```

Returns the total number of people registered in the contract.

#### `getPersonFavoriteNumber(string memory _name)`

```solidity
function getPersonFavoriteNumber(string memory _name) public view returns (uint256 favoriteNumber, bool found)
```

Looks up a person's favourite number by name.
- Returns both the number and a boolean indicating if the person was found
- Prevents confusion between zero values and non-existent entries

#### `updatePersonFavoriteNumber(string memory _name, uint256 _newFavoriteNumber)`

```solidity
function updatePersonFavoriteNumber(string memory _name, uint256 _newFavoriteNumber) public returns (bool success)
```

Updates an existing person's favourite number.
- Searches for the person in the array by comparing name hashes
- Updates both the array and the mapping if found
- Returns a boolean indicating success or failure

#### `clearAllPeople()`

```solidity
function clearAllPeople() public onlyOwner
```

Administrative function to reset the people registry.
- Restricted to contract owner only
- Clears the array but not the mapping (as mappings cannot be efficiently cleared)

## Real-World Use Cases

### 1. User Preference Management

SimpleStorage provides a foundation for storing user preferences on-chain:
- Dapp user settings storage
- User configuration management
- Personal customisation parameters

### 2. Basic Identity Registry

With minor extensions, the contract could serve as:
- Member registry for DAOS
- User profile foundation for decentralised applications
- Participant tracking for blockchain-based events

### 3. Survey and Polling Tool

The number storage capability enables:
- Simple polling mechanisms
- Rating collection systems
- Basic survey tools, where each person submits a numerical response

### 4. Verification Systems

The contract could be adapted for:
- Attestation registry (with the number representing verification status)
- Reputation systems (numbers representing trust scores)
- Access level tracking (numbers indicating permission levels)

### 5. Educational Tool

As demonstrated in its current form:
- Teaching basic smart contract development
- Demonstrating Solidity data structures
- Showcasing event logging and state management

## Deployment Guide

### Prerequisites

- Ethereum wallet with testnet or mainnet ETH
- Solidity development environment (Remix, Hardhat, or Truffle)

### Deployment Steps

1. Compile the contract with Solidity ^0.8.19
2. Deploy to your chosen network
3. The deploying address will automatically become the contract owner
4. Interact with the contract using a web3 interface or blockchain explorer

### Interaction Example

```javascript
// Web3.js example
const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);

// Store a favourite number
await contract.methods.store(42).send({ from: userAddress });

// Add a person
await contract.methods.addPerson("Alice", 7).send({ from: userAddress });

// Retrieve information
const favoriteNumber = await contract.methods.retrieve().call();
const personCount = await contract.methods.getPeopleCount().call();
```

## Security Considerations

- The contract uses Solidity 0.8.19, which includes built-in overflow protection
- Input validation prevents empty strings
- Administrative functions are protected by owner access control
- String comparison is done safely using keccak256 hashing

## Gas Optimization

- Uses appropriate data types for each variable
- Minimizes storage by using a hybrid array/mapping approach
- Read-only functions are marked as `view` to avoid gas costs
- Memory keyword is used appropriately for string parameters

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

*Disclaimer: This smart contract is provided for educational purposes and should be thoroughly audited before any production use.*
