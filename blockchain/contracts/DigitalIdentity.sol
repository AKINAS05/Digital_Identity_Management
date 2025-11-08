// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DigitalIdentity {
    enum Status { NONE, PENDING, VERIFIED, REJECTED }

    struct Identity {
        string cid;          // IPFS CID of JSON (contains user data + file CIDs)
        address owner;       // user wallet
        Status status;       // workflow state
        uint256 createdAt;
        uint256 updatedAt;
    }

    mapping(address => Identity) private identities;
    address[] private applicants;         // for listing in UI
    mapping(address => bool) private seenApplicant; // avoid duplicates
    address public verifier;              // admin / authority

    modifier onlyVerifier() {
        require(msg.sender == verifier, "Not authorized verifier");
        _;
    }

    event IdentitySubmitted(address indexed user, string cid);
    event IdentityVerified(address indexed user);
    event IdentityRejected(address indexed user);
    event VerifierChanged(address indexed oldVerifier, address indexed newVerifier);

    constructor() {
        verifier = msg.sender; // deployer is verifier by default
    }

    // User submits (or re-submits) identity; overwrites previous cid + sets PENDING
    function submitIdentity(string calldata cid) external {
        require(bytes(cid).length > 0, "CID required");

        Identity storage idn = identities[msg.sender];
        if (!seenApplicant[msg.sender]) {
            applicants.push(msg.sender);
            seenApplicant[msg.sender] = true;
        }

        idn.cid = cid;
        idn.owner = msg.sender;
        idn.status = Status.PENDING;
        if (idn.createdAt == 0) {
            idn.createdAt = block.timestamp;
        }
        idn.updatedAt = block.timestamp;

        emit IdentitySubmitted(msg.sender, cid);
    }

    // Verifier actions
    function verifyIdentity(address user) external onlyVerifier {
        Identity storage idn = identities[user];
        require(idn.status == Status.PENDING, "Not pending verification");
        idn.status = Status.VERIFIED;
        idn.updatedAt = block.timestamp;
        emit IdentityVerified(user);
    }

    function rejectIdentity(address user) external onlyVerifier {
        Identity storage idn = identities[user];
        require(idn.status == Status.PENDING, "Not pending verification");
        idn.status = Status.REJECTED;
        idn.updatedAt = block.timestamp;
        emit IdentityRejected(user);
    }

    // Views
    function getIdentity(address user) external view returns (Identity memory) {
        return identities[user];
    }

    function getApplicants() external view returns (address[] memory) {
        return applicants;
    }

    // Helper to fetch status without decoding whole struct
    function getStatus(address user) external view returns (Status) {
        return identities[user].status;
    }

    // Admin
    function setVerifier(address newVerifier) external onlyVerifier {
        require(newVerifier != address(0), "zero address");
        emit VerifierChanged(verifier, newVerifier);
        verifier = newVerifier;
    }
}
