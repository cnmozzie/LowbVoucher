// contracts/LowbVoucher.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
import "./IERC721LOWB.sol";

contract LowbVoucher {
 
    address public owner;
    address public nonFungibleTokenAddress;
    mapping (uint => address) public adminOf;

    // Emitted events
    event VoucherExchanged(uint256 tokenId, string userId);
    event GroupAdminSet(uint256 groupId, address groupAdmin);

    constructor(address nonFungibleToken_) {
        require(nonFungibleToken_ != address(0));
        nonFungibleTokenAddress = nonFungibleToken_;
        owner = msg.sender;
    }
 
    // Stores a new value in the contract
    function exchange(uint256 itemId, string memory userId) public {
        IERC721LOWB nft = IERC721LOWB(nonFungibleTokenAddress);
        uint groupId = nft.groupOf(itemId);
        require(adminOf[groupId] != address(0), "This token is not for exchange.");
        require(nft.ownerOf(itemId) == msg.sender, "You don't own this token.");
        require(nft.getApproved(itemId) == address(this), "Approve this token first.");

        nft.safeTransferFrom(msg.sender, adminOf[groupId], itemId);

        emit VoucherExchanged(itemId, userId);
    }
 
    // set the group admin who can get back the voucher NFTs
    function set_group_admin(uint256 groupId, address groupAdmin) public {
        require(msg.sender == owner, "Only owner can set the group admin!");
        adminOf[groupId] = groupAdmin;
        emit GroupAdminSet(groupId, groupAdmin);
    }
}