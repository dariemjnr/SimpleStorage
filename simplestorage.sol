// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title SimpleStorage
 * @author EnhancedByAI
 * @notice A simple contract for storing and retrieving favorite numbers associated with people
 * @dev Demonstrates basic storage patterns in Solidity
 */
contract SimpleStorage {
    // State variables
    uint256 private myFavoriteNumber;
    
    // Events for state changes
    event FavoriteNumberUpdated(uint256 indexed oldValue, uint256 indexed newValue);
    event PersonAdded(string indexed name, uint256 favoriteNumber, uint256 listPosition);
    
    // Access control
    address public owner;
    
    // Structs
    struct Person {
        uint256 favoriteNumber;
        string name;
    }
    
    // Data structures
    Person[] public listOfPeople;
    mapping(string => uint256) public nameToFavoriteNumber;
    
    /**
     * @notice Sets the contract deployer as the owner
     */
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @notice Modifier to restrict functions to owner only
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "SimpleStorage: Caller is not the owner");
        _;
    }
    
    /**
     * @notice Stores a new favorite number
     * @param _favoriteNumber The number to store
     * @dev Emits FavoriteNumberUpdated event
     */
    function store(uint256 _favoriteNumber) public {
        uint256 oldValue = myFavoriteNumber;
        myFavoriteNumber = _favoriteNumber;
        emit FavoriteNumberUpdated(oldValue, _favoriteNumber);
    }

    /**
     * @notice Retrieves the currently stored favorite number
     * @return The stored favorite number
     */
    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    /**
     * @notice Adds a new person with their name and favorite number
     * @param _name The name of the person
     * @param _favoriteNumber The person's favorite number
     * @dev Emits PersonAdded event
     */
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // Input validation
        require(bytes(_name).length > 0, "SimpleStorage: Name cannot be empty");
        
        // Add to array
        listOfPeople.push(Person(_favoriteNumber, _name));
        
        // Update mapping
        nameToFavoriteNumber[_name] = _favoriteNumber;
        
        // Emit event
        emit PersonAdded(_name, _favoriteNumber, listOfPeople.length - 1);
    }
    
    /**
     * @notice Gets the count of people added to the contract
     * @return The number of people stored
     */
    function getPeopleCount() public view returns (uint256) {
        return listOfPeople.length;
    }
    
    /**
     * @notice Gets a person's favorite number by their name
     * @param _name The name to look up
     * @return favoriteNumber The person's favorite number
     * @return found Whether the person exists in the mapping
     */
    function getPersonFavoriteNumber(string memory _name) public view returns (uint256 favoriteNumber, bool found) {
        // Check if the mapping contains the name
        bool exists = bytes(listOfPeople[nameToFavoriteNumber[_name]].name).length > 0;
        
        if (exists) {
            return (nameToFavoriteNumber[_name], true);
        } else {
            return (0, false);
        }
    }
    
    /**
     * @notice Updates a person's favorite number
     * @param _name The name of the person to update
     * @param _newFavoriteNumber The new favorite number
     * @return success Whether the update was successful
     */
    function updatePersonFavoriteNumber(string memory _name, uint256 _newFavoriteNumber) public returns (bool success) {
        // Input validation
        require(bytes(_name).length > 0, "SimpleStorage: Name cannot be empty");
        
        // Check if person exists
        for (uint i = 0; i < listOfPeople.length; i++) {
            if (keccak256(bytes(listOfPeople[i].name)) == keccak256(bytes(_name))) {
                // Update both the array and mapping
                listOfPeople[i].favoriteNumber = _newFavoriteNumber;
                nameToFavoriteNumber[_name] = _newFavoriteNumber;
                
                emit FavoriteNumberUpdated(nameToFavoriteNumber[_name], _newFavoriteNumber);
                return true;
            }
        }
        
        return false; // Person not found
    }
    
    /**
     * @notice Clears all people from the list (restricted to owner)
     * @dev Completely resets the array and doesn't attempt to clear the mapping
     */
    function clearAllPeople() public onlyOwner {
        delete listOfPeople;
        // Note: This doesn't clear the mapping, as there's no efficient way to do that
        emit PersonAdded("", 0, 0); // Empty event to log the clear operation
    }
}
