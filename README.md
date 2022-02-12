# ERC721-NFT-marketplace
Do you wish to run your own NFT market place.  This may be a solution.

NOTE: The code is not audited. Hence there may be bugs that compromise security. Please use it at your own risk. 

The project consists of three contracts;

- TokenFactory
- SellToken
- BuyToken

### TokenFactory contract
You can construct NFT with this contract powered by OpenZeppelin ERC721 library. You may not need to directly access the contract once deployed.
This contract will normally be accessed from SellToken contract.

Wheny deplying it, you give a name and ticker to your own NFT tokens.  Basically all tokens will be minted under this name and this ticker.
Each token will be indetified by ID (=number).  

### SellToken contract
This contract is deployed everytime a new token is created and sold. Hence the life of the contract ends when the token is sold.

Three parameters below are required when a contract is deployed.
- address of the deployed TokenFactory contract
- URI for your token
- price in wei

The contract has following functions;
- collecting a payment
- transferring a token to a buyer
- transferring proceeds from a sale to an seller

### BuyToken contract
To order a particular token a buyer deploys this contract. It is deployed for each token. Hence the life of the contract ends when the token is sold.
When deploying it a buyer inputs the address of SellToken contract for this particular token. The contract has only one function, 'pay.' 

## Steps
1. Deploy TokenFactory entering token name and ticker as parameters.
2. Deploy SellToken entering the address of TokenFactory deployed in Step 1, token URI and price.
3. Buyer deploys BuyToken entering the address of SellToken for a particular token.
4. Buyer checks a price and calls 'pay' function entering the amount in wei.
5. Check a payment status (calling 'buyer' getter) and transfer the token to the buyer.
6. Transfer the proceeds from the sale to your address.

## Security considerations
- More than two people may place an order for the same token. In this case whoever pays first will get the token (not the one who placed the order first). 
- Once the payment is received by the SellToken, the contract prevents the seller from receiving any more payment whether it's from the same buyer or a different buyer.
- Once the payment is received by the SellToken, it will not accept an order for the same token.
- Seller cannot transfer the token to the buyer before the payment is recieved.
- Seller cannot transfer the proceeds from the sale to his/her address before transferring the token to the buyer.




