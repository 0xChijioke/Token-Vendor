pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT
/** Lots of extra comments just to help myself learn ETH ideas  */
import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller,uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }


  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 numberOfTokens = msg.value * tokensPerEth;

    //emit the event
    emit BuyTokens(msg.sender,msg.value,numberOfTokens);

    yourToken.transfer(msg.sender,numberOfTokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  /**
  @notice Lets the only the owner of the Vendor contract withdraw the money
   */
  function withdraw() public onlyOwner() {
      uint256 contractBal = address(this).balance;
      (bool sent,) = msg.sender.call{value: contractBal}("");
      require(sent,"Failed to send uh oh");
  }

  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 _amount) public {

    //Transfer from allows the spender, who is approved from previous allow() call,
    //to send the token to a different address
    //transferFrom(from,to,amount) <- params
    yourToken.transferFrom(msg.sender, address(this), _amount);

    

    uint256 ethAmount = (_amount / 100);  //amount in eth

    //emit sell event
    emit SellTokens(msg.sender,ethAmount,_amount);

    (bool sent,) = msg.sender.call{value:ethAmount}(""); //call to send eth to user
    require(sent, "Failed to send");
  }

}
