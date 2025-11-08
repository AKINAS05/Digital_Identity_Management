Digital Identity Management

A decentralized identity system where users submit personal details and documents (Aadhaar/PAN) that are stored on IPFS, while verification state (PENDING / VERIFIED / REJECTED) is managed on Ethereum (Hardhat local) via a smart contract. An authorized verifier reviews submissions and approves/rejects them. Users control their identity via wallet (MetaMask), and the identity record is referenced by an IPFS CID.

✨ What this app does :

Users fill a form, upload Aadhar/PAN, and submit → the app uploads files to IPFS, creates a single identity JSON (with file CIDs + basic details), uploads it to IPFS, and stores that JSON CID + PENDING status in the smart contract.

Verifier (deployer/admin) opens the dashboard, loads pending applicants, views documents via IPFS gateway links, and approves/rejects on-chain.

Status is transparent and tamper-resistant (tracked on blockchain) and documents are decentralized (stored on IPFS). The final identity CID acts as the user’s decentralized identity record.

🧠 Why it’s useful :

User ownership: personal data is not on centralized servers; only the CID lives on-chain.

Integrity: IPFS CIDs are content-addressed (any tampering changes the CID).

Auditability: verification events are on-chain, immutable.

Separation of concerns: blockchain stores state; IPFS stores files.

🏗️ Architecture (high level)

Frontend: React (CRA) + ethers + MetaMask

Smart Contract: Solidity (Hardhat local network, chainId 31337)

Storage: Local IPFS daemon (API 127.0.0.1:5001, Gateway 127.0.0.1:8080)

Workflow:

User → Upload docs → Create identity JSON → IPFS (CID)

Contract → submitIdentity(CID) → status = PENDING

Verifier → reviews docs via gateway → verifyIdentity() or rejectIdentity()

Anyone can read getIdentity(address) to see status + CID

📦 Tech Stack

React, ethers.js, MetaMask, Solidity, Hardhat, IPFS (go-ipfs), Node.js

✅ Prerequisites

Node.js LTS (and npm)

MetaMask browser extension

Hardhat (installed via npm as dev dependency)

go-IPFS installed (ipfs available in terminal)

Note: This project is designed to run 100% locally (no sepolia/testnet).

🚀 Local Setup & Run (step-by-step)
1) Start IPFS (with CORS for localhost)

Open a terminal and run:

ipfs daemon

Verify gateway works by visiting:

http://127.0.0.1:8080/ipfs/<any-known-cid>

2) Start local blockchain (Hardhat)

Open a new terminal:

cd blockchain
npx hardhat node

Keep this terminal running. It will print accounts & private keys.

3) Deploy the smart contract (local)

Open another terminal:

cd blockchain
npx hardhat run scripts/deploy.js --network localhost

Copy the deployed contract address from the console.

4) Configure the frontend

Open web/src/blockchain.js and set:

CONTRACT_ADDRESS to the address you just copied

Copy the latest ABI from:

/blockchain/artifacts/contracts/DigitalIdentity.sol/DigitalIdentity.json

to web/src/DigitalIdentity.json (overwrite)

5) MetaMask setup

Add a Custom Network:

Network Name: Hardhat Local

RPC URL: http://127.0.0.1:8545

Chain ID: 31337

Currency: ETH

Import an account using one of the private keys printed by Hardhat node.

Use Account #0 as Verifier (this is the deployer/admin).

Use Account #1 as User for submitting identity.

6) Run the React app
cd web
npm install
npm start

Open http://localhost:3000. 

#Demonstration Video Link :
https://drive.google.com/file/d/1ALdOa_AM8TBuF9po1aOW9L7j7Meq4yZ9/view?usp=sharing
