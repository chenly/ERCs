// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC7626 is Ownable{

    mapping(address => bool) public authorizedUsers; // Mapping of authorized users
    mapping(address => uint256) public accessStartTime; // Mapping of user access start time
    mapping(address => uint256) public accessEndTime; // Mapping of user access end time
    string public metadataURI; // URI for metadata
    string public downloadURI; // URI for data download

    // Event emitted when access is granted to a user
    event AccessGranted(address indexed user, uint256 start, uint256 end);

    // Event emitted when access is revoked from a user
    event AccessRevoked(address indexed user);

    // Constructor to initialize contract with owner and URIs
    constructor(address initialOwner, string memory _metadataURI, string memory _downloadURI) Ownable(initialOwner) {
        metadataURI = _metadataURI;
        downloadURI = _downloadURI;
    }

    // Function to grant access to a user for a specified time period
    function grantAccess(address user, uint256 start, uint256 end) public onlyOwner {
        authorizedUsers[user] = true;
        accessStartTime[user] = start;
        accessEndTime[user] = end;
        emit AccessGranted(user, start, end);
    }

    // Function to revoke access of a user
    function revokeAccess(address user) public onlyOwner {
        authorizedUsers[user] = false;
        accessStartTime[user] = 0;
        accessEndTime[user] = 0;
        emit AccessRevoked(user);
    }

    // Function to check if a user is authorized based on current time
    function isUserAuthorized(address user) public view returns (bool) {
        return authorizedUsers[user] && (block.timestamp >= accessStartTime[user] || accessStartTime[user] == 0) && (block.timestamp <= accessEndTime[user] || accessEndTime[user] == 0);
    }

    // Function to set new metadata URI, accessible only by the owner
    function setMetadataURI(string memory newURI) public onlyOwner {
        metadataURI = newURI;
    }

    // Function to set new download URI, accessible only by the owner
    function setDownloadURI(string memory newURI) public onlyOwner {
        downloadURI = newURI;
    }
}
