// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "hardhat/console.sol";

contract Counter {

    //global variables

    //amount in pool
    uint256 totalPoolAmount;

    //team address
    address team;

    //dynamic arrays
        //users (address[])
    address[] users;

    //mappings
        //userStakes: user (address) -> amountStaked (uint256)
    mapping(address => uint256) userStakes;

    //events
        //deposit (user (address), amount (uint256), timestamp (uint256))
    event Deposit(address user, uint256 amount, uint256 timestamp);
        //withdrawal (user (address), amount (uint256), timestamp(uint256))
    event Withdrawal(address user, uint256 amount, uint256 timestamp);
        //reward (user(address), amount (uint256), timestamp(uint256))
    event Reward(address user, uint256 amount, uint256 timestamp);

    //constructor
    constructor(address _team)  {
        //set Team address
        team = _team;
    }

    //functions
    //deposit stake ( payable, external)
    function depositStake() payable external {
        //require msg.value > 0
        require(msg.value > 0);
        //if userStakes[msg.sender] is 0,
        if (userStakes[msg.sender] == 0) {
            //push msg.sender to users array
            users.push(msg.sender);
        }
        //add msg.value to userStakes[msg.sender]
        userStakes[msg.sender] = userStakes[msg.sender] += msg.value;
        //add msg.value to total pool amount
        totalPoolAmount += msg.value;

        //event Deposit
        emit Deposit(msg.sender, msg.value, block.timestamp);
    }
    //deposit reward (external onlyTeam)
    function depositReward() payable external {
        //require msg.sender == team
        require(msg.sender == team);
        //require pool amount > 0
        require (totalPoolAmount > 0);
        //for every user in pool,
        for (uint256 i; i < users.length; i++) {
            address user = users[i];
            //percentage = userStakes[user] * 100 / total amount in pool
            uint256 percentage = userStakes[user] * 100 / totalPoolAmount;
            //reward = userStakes[user] + msg.value * percentage / 100
            uint256 reward = userStakes[user] + msg.value * percentage / 100;
            //add reward to user's amount staked
            userStakes[user] += reward;
        }
        //event Reward
        emit Reward((msg.sender), msg.value, block.timestamp);
    }
    //withdraw stake (external)
    function withdraw(uint256 _amount) payable external {
        //require userStakes[msg.sender] > 0
        require(userStakes[msg.sender] > 0, "user hasn't staked in pool!");
        //require msg.value > 0
        require(msg.value > 0, "can't withdraw 0 ETH");
        //require userStakes[msg.sender] - _amount > 0
        require(userStakes[msg.sender] - _amount > 0, "can't withdraw more than is staked");
        //subtract _amount from user's amount staked
        userStakes[msg.sender] -= _amount;
        //call fallback to send ether rewards to msg.sender'
        (bool success, ) = msg.sender.call{value:_amount}("");

        //require transfer was successul
        require(success, "return of ETH was unsuccessful");

        //event Withdrawal
        emit Withdrawal(msg.sender, _amount, block.timestamp);

    }
}
