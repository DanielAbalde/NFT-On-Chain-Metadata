<h1 align="center"> NFT On-Chain Metadata </h1> 
<p align="center">Easily and quickly create ERC721 and ERC115 contracts with on-chain metadata, supporting dynamic metatada, parametric NFTs, SVG-based NFTs and HTML/JS-based NFTs.</p>



## 😎 Overview

These contracts do not unlock new functionality, but it makes it easy and quick to implement so that any web developer capable of deploying a smart contract can create html-based NFT applications.
 
[OnChainMetadata.sol](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/OnChainMetadata.sol) is a storage contract containing the metadata for the contract and its tokens and the functionality to create the token URI and contract URI expected by NFT platforms.

```solidity
abstract contract OnChainMetadata 
{ 
  struct Metadata
  {
    uint256 keyCount;                           // number of metadata keys
    mapping(bytes32 => bytes[]) data;           // key => values
    mapping(bytes32 => uint256) valueCount;     // key => number of values
  }
   
  Metadata _contractMetadata;                   // metadata for the contract
  mapping(uint256 => Metadata) _tokenMetadata;  // metadata for each token

  bytes32 constant key_contract_name = "name";
  bytes32 constant key_contract_description = "description";
  bytes32 constant key_contract_image = "image";
  bytes32 constant key_contract_external_link = "external_link";
  bytes32 constant key_contract_seller_fee_basis_points = "seller_fee_basis_points";
  bytes32 constant key_contract_fee_recipient = "fee_recipient";

  bytes32 constant key_token_name = "name";
  bytes32 constant key_token_description = "description";
  bytes32 constant key_token_image = "image";
  bytes32 constant key_token_animation_url = "animation_url";
  bytes32 constant key_token_external_url = "external_url";
  bytes32 constant key_token_background_color = "background_color";
  bytes32 constant key_token_youtube_url = "youtube_url";
  bytes32 constant key_token_attributes_trait_type = "trait_type";
  bytes32 constant key_token_attributes_trait_value = "trait_value";
  bytes32 constant key_token_attributes_display_type = "trait_display"; 

  function _getValues(uint256 tokenId, bytes32 key) internal view returns (bytes[] memory){ (...) }
  function _setValues(uint256 tokenId, bytes32 key, bytes[] memory values) internal { (...) }
  
  (...)
```

[ERC721OnChainMetadata.sol](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) and [ERC1155OnChainMetadata.sol](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) are simple implementions for the main NFT contracts, returning the URIs in the standard methods. **You should use one of these or create your own version.**

#### Examples 

[Example1-721-svg.sol](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/Example1-721-svg.sol) is an ERC271 using on-chain SVG images. [See on OpenSea](https://opensea.io/collection/erc721onchainmetadata-example-1-v2). 

[Example2-721-p5js.sol](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/Example2-721-p5js.sol) is an ERC721 using a p5.js sketch hosted on IPFS. [See on OpenSea](https://opensea.io/collection/erc721onchainmetadata-with-p5-js).

[Example3-1155-html.sol](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/Example3-1155-html.sol) is an ERC1155 using on-chain SVG images. [See on Opensea](https://opensea.io/collection/erc1155onchainmetadata-example-3).

#### Setup

I started working with Truffle + Alchemy but due to problems deploying in Mumbai I switched to Hardhat + Alchemy, I didn't remove the Truffle configuration to preserve the tests (I know Hardhat has plugins to use it, but it's worth it here).

## 🔎 Disclaimer

It took me several refactorings to find a good balance between functionality, ease of implementation and cost of gas. Since the contract takes care of creating the tokenURI as an embedded json resource and handles a lot of text and possibly redudant information (repeated in the tokenId->metadata map for example), gas consumption is an issue in this kind of NFTs. My advice (apart from leaving Ethereum L1 in the past) is to try building your functionality on top of [ERC721OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) or [ERC1155OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) and if gas turns out to be a problem, take the *_createTokenURI()* (and *_createContractURI()* if needed) method code from [OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/OnChainMetadata.sol) and adapt it into your own contract with only the metadata you need.

Also note that NFT platforms such as OpenSea or LooksRare may have their own restrictions for html-based NFTs. Use it at your own risk.


## 🔌 Usage

The basic use is to inherit from [ERC721OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) or [ERC1155OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol), set contract metadata from constructor and set token metadata from mint function.

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol";

// 1) Inherit from ERC721OnChainMetadata or ERC1155OnChainMetadata

contract MyNFT is ERC721OnChainMetadata
{ 
    constructor() ERC721OnChainMetadata("MyNFT", "MyNFT"){

        // 2) Set contract metadata: name, description, image, external link, seller fee basis points, fee recipient.

        _addValue(_contractMetadata, key_contract_name, abi.encode("MyNFT"));
        _addValue(_contractMetadata, key_contract_description, abi.encode("Blah blah blah"));
        _addValue(_contractMetadata, key_contract_image, abi.encode("<path-to-contract-image>"));
        _addValue(_contractMetadata, key_contract_external_link, abi.encode("<webpage>"));
        _addValue(_contractMetadata, key_contract_seller_fee_basis_points, abi.encode(200));
        _addValue(_contractMetadata, key_contract_fee_recipient, abi.encode(_msgSender()));

    }
  
  // 3) On your minting function (or whenever a token is minted) set the token metadata: name, description, image, external link, animation url, external url, background color, youtube url, attributes.
  // If your NFT is burnable, remember to delete its metadata.

  function _safeMintWithMetadata(uint256 tokenId, string memory name, string memory description, string memory image) internal{
        _setValue(tokenId, key_token_name, abi.encode(name));
        _setValue(tokenId, key_token_description, abi.encode(description));
        _setValue(tokenId, key_token_image, abi.encode(image));
        _safeMint(_msgSender(), tokenId, ""); 
    }

  // 4) Optionally you can add your own metadata using byte32 keys and bytes[] values.
}
```
 
## ☕ Contribute  

Feel free to open an Issue or Pull Request!

You can make an offer on the example NFTs, if it's at least a coffee I'll take it!

My address: daniga.eth or 0x4443049b49caf8eb4e9235aa1efe38fcfa0055a1.

We can talk about NFT development on [Discord](https://discord.gg/QPMapnqAh7).

Follow me on Twitter [@DGANFT](https://twitter.com/DGANFT)!