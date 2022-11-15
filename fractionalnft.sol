// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.8.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts@4.8.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MyToken is ERC20, Ownable, ERC20Permit {
    IERC721 public collection;
    uint256 public tokenId;
    bool public initialized;
    bool public forSale;
    uint256 public salePrice;
    bool public canRedeem;

    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {}

    function initialize(address _collection, uint256 _tokenId, uint256 _amount) external onlyOwner {
        require(!initialized, "Already initialized");
        collection = IERC721(_collection);
        collection.safeTransferFrom(msg.sender, address(this), _tokenId);   
        tokenId = _tokenId;
        initialized = true;
        _mint(msg.sender, _amount);
    } 

    function putForSale(uint256 price) external onlyOwner {
        salePrice = price;
        forSale = true;
    }

    function purchase() external payable {
        require(forSale, "Not for Sale");
        require(msg.value >= salePrice, "Not enough ether sent");
        collection.transferFrom(address(this), msg.sender, tokenId);
        forSale = false;
        canRedeem = true;
    }

    // function mint(address to, uint256 amount) public onlyOwner {
    //     _mint(to, amount);
    // }
}
