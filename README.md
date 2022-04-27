<h1 align="center"> NFT On-Chain Metadata </h1> 



<p align="center">Easily and quickly create ERC721 and ERC115 contracts with on-chain metadata, supporting dynamic metatada, parametric NFTs, SVG-based NFTs and HTML/JS-based NFTs.</p>



## 😎 Overview

These contracts do not unlock new functionality, but it makes it easy and quick to implement so that any web developer capable of deploying a smart contract can create html-based NFT applications.
 
[OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/OnChainMetadata.sol) is a storage contract containing the metadata for the contract and its tokens and the functionality to create the token URI and contract URI expected by NFT platforms.

```sol
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

[ERC721OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) and [ERC1155OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) are simple implementions for the main NFT contracts. You should use one of these or create your own version.




## ⚠️ Disclaimer

It took me several refactorings to find a good balance between functionality, ease of implementation and cost of gas. Since the contract takes care of creating the tokenURI as an embedded json resource and handles a lot of text and possibly redudant information (repeated in the tokenId->metadata map for example), gas consumption is an issue in this kind of NFTs. My advice (apart from leaving Ethereum L1 in the past) is to try building your functionality on top of [ERC721OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) or [ERC1155OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/ERC721OnChainMetadata.sol) and if gas turns out to be a problem, take the *_createTokenURI()* (and *_createContractURI()* if needed) method code from [OnChainMetadata](https://github.com/DanielAbalde/NFT-On-Chain-Metadata/blob/master/contracts/OnChainMetadata.sol) and adapt it into your own contract with only the metadata you need.

Also note that NFT platforms such as OpenSea or LooksRare may have their own restrictions for html-based NFTs.

## 🔌 Usage

// if burn, delete _tokenMetadata[tokenId]


## ☕ Contribute  