// Get funds from users
// Withdraw funds
// Set a min funding value in USD

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

// Cost = 833,895 gas
// new cost (after constant) = 814,335 gas
// How to make it more gas efficient??
// Constant & Immutable


error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINUMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor () {
        i_owner = msg.sender;    
    }

    function fund() public payable{
        /*set a min fund value in USD
        How to send ETH to this contract? */
         require(msg.value.getConversionRate() >= MINUMUM_USD, "Didn't send enough!"); //1e18 == 1 * 10 ** 18  - msg.value => 18 decimals
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
        // What is reverting? 
        // undo any action before, and send remaining gas back.
    }

    
    function withdraw() public onlyOwner {
        
        /* starting index, ending index, step amount */
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex ++ ) 
         {
            address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require (callSuccess, "Call failed");

        // 3 different ways of sending ETH from a contract

        // transfer : payable(msg.sender).transfer(address(this).balance);  {Keep In Mind that msg.sender is address and payable(msg.sender) is payable address}
        
        // send : bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed");
        
        // call (Recomemnded) : (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("")
        // require (callSuccess, "Call failed");
        
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not the owner!");
        // _; // Doing the rest of the code
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }    

// what happens if someone sends ETH to this contract without calling fund function?
receive() external payable {
    fund();
    }

fallback() external payable {
    fund();
    }
}