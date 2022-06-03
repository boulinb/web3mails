// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Owner.sol";

contract Web3Mails is Owner {
   
    struct Mails {
        bytes32 hashedMail;
        string toAddress;
    }

    // Default price set to 0.01 eth / mails
    uint mailPrice = 10000000000000000;

    mapping(address => uint) private availableMailsByAddress;
    mapping(address => Mails[]) private mailsByAddress;
    
    function buyMails() public payable {
        require(msg.value >= mailPrice);
       
        availableMailsByAddress[msg.sender] += (msg.value / mailPrice);
    }

    function storeMail(string memory _hashedMail, string memory _toAddress) public payable {
        require(availableMailsByAddress[msg.sender] > 0);
        Mails memory tmpMail;

        tmpMail.hashedMail = stringToBytes32(_hashedMail);
        tmpMail.toAddress = _toAddress;

        mailsByAddress[msg.sender].push(tmpMail);
        availableMailsByAddress[msg.sender]--;
    }
    
    function getAvailableMailsByAddress(address _ownerKey) public view returns (uint counts) {
        counts = availableMailsByAddress[_ownerKey];
    }

    function getMailListByAddress(address _ownerKey) public view returns (Mails[] memory) {
        return mailsByAddress[_ownerKey];
    }

    function getContractEth(address payable pubKey) public payable isOwner {
        pubKey.transfer(address(this).balance);
    }

    function setMailPrice(uint price) public payable isOwner {
        mailPrice = price;
    }
    
    function getMailPrice() public view returns (uint price) {
        price = mailPrice;
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest;
        tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }
}
