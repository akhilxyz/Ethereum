
# A Simple ERC-721 Example



What is it?

![](https://cdn-images-1.medium.com/max/2000/0*jr7S0JF8XiousKKz.png)

ERC-721 tokens are a hot topic today with the advent of [crypto kitties](https://www.cryptokitties.co/) and a host of other digital collectibles spawned by its success. The [ERC-721 standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md) has gone through a couple iterations and is more or less in place now, so expect more and more players to enter this space. The basic premise of these [non-fungible tokens](https://en.wikipedia.org/wiki/Non-Fungible_Tokens) is that each token is unique and therefore cannot be exchanged on a 1:1 basis like an ERC20 token may be. There are many use cases where a unique tangible or digital asset may represented by these ERC-721 tokens, such as real estate, art, precious stones, etc. Actually, the digital collectible use case is probably the lowest market value use case of them all.

### Setup the project

#### In this project you can create your own Color tokens like crypto kitties

![](https://github.com/akhilxyz/Solidity-0.7.0/blob/master/ERC_721/tokens.jpg)

    clone the project
    
 Open ERC_721 Directory
 
 Make sure that you have node, npm and truffle installed

 
    run commands:
    - npm install
    - npm install truffle
    
Install zeppelin dependency

    - npm install @openzeppelin/contracts

Install ganache dependency

    - install and run ganache

Install MetaMask dependency

    - set network to custom RCP
    - set RCP url to ganache network
 
 Open project Directory and run commands
    
    - truffle migrate --reset
    - truffle migrate
    
Run the migrate script and verify that it deploys without errors

    - npm run start
