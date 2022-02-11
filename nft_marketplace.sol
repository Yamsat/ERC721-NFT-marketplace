pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/ownership/Ownable.sol";

contract TokenFactory is ERC721Full {
    using Counters for Counters.Counter;
    Counters.Counter private token_ids;
    address owner;

    constructor (string memory _tokenName, string memory _tokenTicker) ERC721Full(_tokenName, _tokenTicker) public {
        owner = msg.sender;
    }

    uint public token_id;

    function addToken(string memory uri) public {
        address creator = msg.sender;
        token_ids.increment();
        token_id = token_ids.current();
        _mint(creator, token_id);
        _setTokenURI(token_id, uri);
    }
}

contract SellToken {
    TokenFactory token;
    address payable public owner;
    uint public price;
    string public uri;
    uint item_id;

    constructor (TokenFactory _token, string memory _uri, uint _price) public {
        
        owner = msg.sender;
        token = _token;
        uri = _uri;
        token.addToken(uri);
        item_id = token.token_id();
        price = _price;
    }

    bool public sold;
    function setSold () internal {
        sold = true;
    }

    address public buyer;
    function setBuyer () internal {
        buyer = msg.sender;
        setSold();
    }

    function () external payable {
       require(address(this).balance == msg.value);
       require(msg.value == price);
       require(sold == false);
       setBuyer();
    }


    BuyToken buy;
    bool isTokenTransferred;

    function transferToken () public {
        require(msg.sender == owner, "You are not the owner");
        require(address(this).balance == price, "Payment not received");
        buy = BuyToken(buyer);
        token.safeTransferFrom(token.ownerOf(item_id), buy.customer(), item_id);
        isTokenTransferred = true;
    } 

    function collectPayment () public {
        require(msg.sender == owner, "You are not the owner");
        require(isTokenTransferred == true, "Token not transferred");
        owner.transfer(address(this).balance);
    }

}



contract BuyToken {
    SellToken sell; 
    uint public price;
    address public customer;
    address seller;

    constructor (SellToken _sell, string memory blank) public {
        customer = msg.sender;
        sell = _sell;
        price = sell.price();
        seller = sell.owner();
    }

    function pay () public payable {
        require(price !=0, "Not available");
        require (msg.value == price, "Amount is incorrect");
        require (msg.sender == customer, "This is not your order");
        (bool success, ) = address(sell).call.value(msg.value)(abi.encodeWithSignature("setBuyer()"));
        require(success, "Payment failed");
        price = 0;
    }

}


