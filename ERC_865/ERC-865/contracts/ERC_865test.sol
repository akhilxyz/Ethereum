pragma solidity 0.4.25;

import "./ERC865.sol";

contract IntellimatixERC865 is ERC865 {
  
    string public name = "ERC_865test";
    string public symbol = "i865";
    uint8 public decimals = 0;
    uint256 public INITIAL_SUPPLY;

    constructor() public {
        _mint(msg.sender, 1000);
        INITIAL_SUPPLY = balanceOf(msg.sender);
    }
}
