// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
   
import "@openzeppelin/contracts/utils/Strings.sol"; 
import "@openzeppelin/contracts/utils/Base64.sol"; 
 
/**
 * @title NFT contract with on-chain metadata,
 * making quick and easy to create html/js NFTs, parametric NFTs or any NFT with dynamic metadata.
 * @author Daniel Gonzalez Abalde aka @DGANFT aka DaniGA#9856.
 * @dev The developer is responsible for assigning metadata for the contract and tokens
 * by inheriting this contract and using _addValue() and _setValue() methods. The tokenURI()
 * and contractURI() methods of this contract are responsible for converting the metadata
 * into a Base64-encoded json readable by OpenSea, LooksRare and many other NFT platforms. 
 */
contract OnChainMetadata 
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
 
  /**
   * @dev Get the values of a token metadata key.
   * @param tokenId the token identifier.
   * @param key the token metadata key.
   */
  function _getValues(uint256 tokenId, bytes32 key) internal view returns (bytes[] memory){ 
    return _tokenMetadata[tokenId].data[key];
  }
  /**
   * @dev Get the first value of a token metadata key.
   * @param tokenId the token identifier.
   * @param key the token metadata key.
   */
  function _getValue(uint256 tokenId, bytes32 key) internal view returns (bytes memory){ 
    bytes[] memory array = _getValues(tokenId, key);
    if(array.length > 0){
      return array[0];
    }else{
      return "";
    } 
  }
  /**
   * @dev Get the values of a contract metadata key. 
   * @param key the contract metadata key.
   */
  function _getValues(bytes32 key) internal view returns (bytes[] memory){ 
    return _contractMetadata.data[key];
  }
  /**
   * @dev Get the first value of a contract metadata key. 
   * @param key the contract metadata key.
   */
  function _getValue(bytes32 key) internal view returns (bytes memory){ 
    bytes[] memory array = _getValues(key);
    if(array.length > 0){
      return array[0];
    }else{
      return "";
    } 
  }
  /**
   * @dev Set the values on a token metadata key.
   * @param tokenId the token identifier.
   * @param key the token metadata key.
   * @param values the token metadata values.
   */
  function _setValues(uint256 tokenId, bytes32 key, bytes[] memory values) internal {
    Metadata storage meta = _tokenMetadata[tokenId];
    
    if(meta.valueCount[key] == 0){ 
        _tokenMetadata[tokenId].keyCount = meta.keyCount + 1;
    } 
    _tokenMetadata[tokenId].data[key] = values;
    _tokenMetadata[tokenId].valueCount[key] = values.length;
  }
  /**
   * @dev Set a single value on a token metadata key.
   * @param tokenId the token identifier.
   * @param key the token metadata key.
   * @param value the token metadata value.
   */
  function _setValue(uint256 tokenId, bytes32 key, bytes memory value) internal {
    bytes[] memory values = new bytes[](1);
    values[0] = value;
    _setValues(tokenId, key, values);
  }
  /**
   * @dev Set values on a given Metadata instance.
   * @param meta the metadata to modify.
   * @param key the token metadata key.
   * @param values the token metadata values.
   */
  function _addValues(Metadata storage meta, bytes32 key, bytes[] memory values) internal {
      require(meta.valueCount[key] == 0, "Metadata already contains given key");
      meta.keyCount = meta.keyCount + 1;
      meta.data[key] = values;
      meta.valueCount[key] = values.length;
  }
  /**
   * @dev Set a single value on a given Metadata instance.
   * @param meta the metadata to modify.
   * @param key the token metadata key.
   * @param value the token metadata value.
   */
  function _addValue(Metadata storage meta, bytes32 key, bytes memory value) internal { 
      bytes[] memory values = new bytes[](1);
      values[0] = value;
      _addValues(meta, key, values);
  }
 
  function _createTokenURI(uint256 tokenId) internal view virtual returns (string memory)
  { 
    bytes memory attributes;
    bytes[] memory trait_type = _getValues(tokenId, key_token_attributes_trait_type);
    if(trait_type.length > 0){
        attributes = '[';
        bytes[] memory trait_value = _getValues(tokenId, key_token_attributes_trait_value);
        bytes[] memory trait_display = _getValues(tokenId, key_token_attributes_display_type);
        for(uint256 i=0; i<trait_type.length; i++){
            attributes = abi.encodePacked(attributes, i > 0 ? ',' : '', '{',
            bytes(trait_display[i]).length > 0 ? string(abi.encodePacked('"display_type": "' , string(abi.decode(trait_display[i], (string))), '",')) : '', 
            '"trait_type": "' , string(abi.decode(trait_type[i], (string))), '", "value": "' , string(abi.decode(trait_value[i], (string))), '"}');
        }
        attributes = abi.encodePacked(attributes, ']');
    }
   
    string memory name = string(abi.decode(_getValue(tokenId, key_token_name), (string)));
    string memory description = string(abi.decode(_getValue(tokenId, key_token_description), (string))); 
    bytes memory image = _getValue(tokenId, key_token_image); 
    bytes memory animation_url = _getValue(tokenId, key_token_animation_url);
    bytes memory external_url = _getValue(tokenId, key_token_external_url);
    bytes memory background_color = _getValue(tokenId, key_token_background_color);
    bytes memory youtube_url = _getValue(tokenId, key_token_youtube_url); 

    return string(abi.encodePacked('data:application/json;base64,', Base64.encode(abi.encodePacked(
        '{',
            '"name": "', name, '", ',
            '"description": "', description, '"',
            bytes(image).length > 0 ? string(abi.encodePacked(', "image": "', string(abi.decode(image, (string))), '"')) : '',
            bytes(animation_url).length > 0 ? string(abi.encodePacked(', "animation_url": "', string(abi.decode(animation_url, (string))), '"')) : '',
            bytes(external_url).length > 0 ? string(abi.encodePacked(', "external_url": "', string(abi.decode(external_url, (string))), '"')) : '',
            bytes(attributes).length > 0 ? string(abi.encodePacked(', "attributes": ', attributes)) : '',
            bytes(background_color).length > 0 ? string(abi.encodePacked(', "background_color": ', string(abi.decode(background_color, (string))))) : '',
            bytes(youtube_url).length > 0 ? string(abi.encodePacked(', "youtube_url": ', string(abi.decode(youtube_url, (string))))) : '',
        '}'
        ))
    ));
  }

  function _createContractURI() internal view virtual returns (string memory) {
     
        bytes memory name = _getValue(key_contract_name); 
        bytes memory description = _getValue(key_contract_description);
        bytes memory image = _getValue(key_contract_image); 
        bytes memory external_url = _getValue(key_contract_external_link);
        bytes memory seller_fee_basis_points = _getValue(key_contract_seller_fee_basis_points);
        bytes memory fee_recipient = _getValue(key_contract_fee_recipient);

        return string(abi.encodePacked('data:application/json;base64,', Base64.encode(abi.encodePacked(
          '{',
              '"name": "', string(abi.decode(name, (string))), '"', 
              bytes(description).length > 0 ? string(abi.encodePacked(', "description": "', string(abi.decode(description, (string))), '"')) : '',
              bytes(image).length > 0 ? string(abi.encodePacked(', "image": "', string(abi.decode(image, (string))), '"')) : '',
              bytes(external_url).length > 0 ? string(abi.encodePacked(', "external_link": "', string(abi.decode(external_url, (string))), '"')) : '',
              bytes(seller_fee_basis_points).length > 0 ? string(abi.encodePacked(', "seller_fee_basis_points": ', Strings.toString(uint256(abi.decode(seller_fee_basis_points, (uint256)))), '')) : '', 
              bytes(fee_recipient).length > 0 ? string(abi.encodePacked(', "fee_recipient": "', Strings.toHexString(uint256(uint160(address(abi.decode(fee_recipient, (address))))), 20), '"')) : '',
          '}'
      ))));
  }

}

 