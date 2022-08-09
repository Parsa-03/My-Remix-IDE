// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8; // comment!!

contract SimpleStorage {
    // boolean, uint, int, address, bytes
    
    uint256 favoriteNumber; 
    // default is 0
    // This gets initialized to zero!
   
   mapping (string => uint256) public nameToFavotiteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public favoriteNumberList;
    People[] public people;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
        
    }

    function retrieve() public view returns(uint256){
        return favoriteNumber;
    } // view , pure functions when called alone , dont spend gas
    
    // calldata, memory, storage
    function addPerson (string memory _name, uint256 _favoriteNumber) public {
        People memory newPerson = People(_favoriteNumber, _name);
        people.push(newPerson);
        nameToFavotiteNumber[_name] = _favoriteNumber;
    }
   
}

