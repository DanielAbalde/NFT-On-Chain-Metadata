// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "./ERC1155OnChainMetadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
* 0x1bfbd4972346D6f3e8e2624D39283e894e2b9472
*/

contract Example3ERC1155OnChainMetadata is ERC1155OnChainMetadata, Ownable
{
  mapping(uint256 => bool) _ids;

  constructor() ERC1155OnChainMetadata()
  {
    _addValue(_contractMetadata, key_contract_name, abi.encode("ERC1155OnChainMetadata Example 3"));
    _addValue(_contractMetadata, key_contract_description, abi.encode(string(abi.encodePacked("Simple example of ERC1155OnChainMetadata using html. See ", "https://github.com/DanielAbalde/NFT-On-Chain-Metadata", "."))));
    _addValue(_contractMetadata, key_contract_image, abi.encode(createSVG()));
    _addValue(_contractMetadata, key_contract_external_link, abi.encode("https://github.com/DanielAbalde/NFT-On-Chain-Metadata"));
    _addValue(_contractMetadata, key_contract_seller_fee_basis_points, abi.encode(200));
    _addValue(_contractMetadata, key_contract_fee_recipient, abi.encode(_msgSender()));

    mintWithMetadata(_msgSender(), 0, 10, "First Test", "First test of ERC1155OnChainMetadata", "https://gateway.pinata.cloud/ipfs/QmUcith5mSybWjN1gwT1UfsK4v4LeBsiHRrKA3K6LeGRaS", "https://gateway.pinata.cloud/ipfs/QmSR38cmJMAqdRrqBkmEWUdwyQ7zdAmiFD2VXXRKtv4Z9x/");
  }
 
  function mintWithMetadata(address to, uint256 id, uint256 amount, string memory name, string memory description, string memory imageURI, string memory url) public onlyOwner{ 
    require(_ids[id] == false, "ERC1155OnChainMetadata: mintWithMetadata: id already exists");
    _setValue(id, key_token_name, abi.encode(name));
    _setValue(id, key_token_description, abi.encode(description));
    _setValue(id, key_token_image, abi.encode(imageURI)); 
    _setValue(id, key_token_animation_url, abi.encode(url));
     
    _ids[id] = true;

    _mint(to, id, amount, "");
  }

  function createSVG() public pure returns (string memory){   
    return string(abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(bytes(string(abi.encodePacked(
        '<svg height="350" width="350" viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg"><rect height="100%" width="100%" fill="white"/><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle">HTML<animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 175 175" to="360 175 175" dur="2s" repeatCount="indefinite"/></text> SVG not supported. <style><![CDATA[ text {font: bold 50px Verdana, Helvetica, Arial, sans-serif;}]]></style></svg>'
    ))))));
  }
}