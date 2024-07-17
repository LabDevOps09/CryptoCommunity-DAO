// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingContract {
    using SafeMath for uint256;

    IERC20 public comToken;
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public startTime;

    constructor(address tokenAddress) {
        comToken = IERC20(tokenAddress);
    }

    function stakeTokens(uint256 amount) public {
        // Transfer tokens to this contract for staking
        comToken.transferFrom(msg.sender, address(this), amount);

        // Update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender].add(amount);

        // Set the stake start time
        if (startTime[msg.sender] == 0) {
            startTime[msg.sender] = block.timestamp;
        }
    }

    function unstakeTokens() public {
        uint256 balance = stakingBalance[msg.sender];
        require(balance > 0, "You do not have staked tokens!");

        // Calculate rewards based on time staked
        uint256 reward = calculateReward(msg.sender);

        // Reset staking balance and start time
        stakingBalance[msg.sender] = 0;
        startTime[msg.sender] = 0;

        // Transfer tokens and rewards back to user
        comToken.transfer(msg.sender, balance);
        comToken.transfer(msg.sender, reward);
    }

    function calculateReward(address user) public view returns (uint256) {
        uint256 timeStaked = block.timestamp.sub(startTime[user]);
        // Simplified example: Reward calculation based on time staked
        return stakingBalance[user].mul(timeStaked).div(365 days);
    }
}
