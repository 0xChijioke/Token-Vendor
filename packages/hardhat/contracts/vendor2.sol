pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(
        address seller,
        uint256 amountOfTokens,
        uint256 amountOfETH
    );

    using SafeMath for uint256;

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy tokens.");
        uint256 amount = msg.value.mul(tokensPerEth);
        yourToken.transfer(msg.sender, amount);
        emit BuyTokens(msg.sender, msg.value, amount);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH. Ownership will be renounced at a later stage.
    function withdraw() public onlyOwner {
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "Ether transfer failed.");
    }

    // ToDo: create a sellTokens() function:

    function sellTokens(uint256 amount) public {
        yourToken.transferFrom(msg.sender, address(this), amount);
        uint256 ethToSend = amount.div(tokensPerEth);
        (bool sent, ) = payable(msg.sender).call{value: ethToSend}("");
        require(sent, "Eth transfer failed.");
        emit SellTokens(msg.sender, amount, ethToSend);
    }
}