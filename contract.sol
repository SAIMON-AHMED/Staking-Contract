// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {

    address public owner;
    IERC20 public token;
    uint256 totalStaked;
    mapping(address => uint256) stakedToken;
    mapping(address => uint256) tokenBalance;
    mapping(address => uint256) interest;
    mapping(address => uint256) duration;

    constructor(address _token) {
        token = IERC20(_token);
        owner = msg.sender;
    }

    // allows users to stake tokens
    function stake(uint256 amount) public {
        require(amount > 0, "Invalid amount");
        require(token.balanceOf(msg.sender) >= amount, "You don't have enough tokens to stake.");

        if (stakedToken[msg.sender] > 0) {
            interest[msg.sender] = getAccruedInterest(msg.sender);
            token.transfer(msg.sender, stakedToken[msg.sender] + interest[msg.sender]);
            totalStaked -= stakedToken[msg.sender];
            stakedToken[msg.sender] = 0;
            interest[msg.sender] = 0; 
        }
        token.transferFrom(msg.sender, address(this), amount);
        stakedToken[msg.sender] = amount;
        totalStaked += amount;
        duration[msg.sender] = block.timestamp;

    }

    // allows users to reedem staked tokens
    function redeem(uint256 amount) public {
        require(amount > 0 && amount <= stakedToken[msg.sender], "Invalid amount");
        token.transfer(msg.sender, amount);
        stakedToken[msg.sender] -= amount;
        totalStaked -= amount;
    }

    // transfers rewards to staker
    function claimInterest() public {
        require(stakedToken[msg.sender] > 0, "You didn't stake any token");
        interest[msg.sender] = getAccruedInterest(msg.sender);
        require(interest[msg.sender] > 0, "You don't have any reward to claim");
        token.transfer(msg.sender, interest[msg.sender]);
        duration[msg.sender] = block.timestamp;
    }

    // returns the accrued interest
    function getAccruedInterest(address user) public view returns (uint256 reward) {
        uint256 time = block.timestamp - duration[user];

        if (time >= 1 days && time < 1 weeks) reward = stakedToken[msg.sender] / 100;
        else if(time >= 1 weeks && time < 30 days) reward = stakedToken[msg.sender] / 10;
        else if(time >= 30 days) reward = stakedToken[msg.sender] / 2;
        else reward = 0;

    }

    // allows owner to collect all the staked tokens
    function sweep() public {
        require(msg.sender == owner, "Only owner can call this function");
        token.transfer(owner, totalStaked);
    }
    
}
