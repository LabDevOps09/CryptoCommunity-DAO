// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract COMToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("CommunityCoin", "COM") {
        _mint(msg.sender, initialSupply);
    }
}
