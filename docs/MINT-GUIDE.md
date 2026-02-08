# EtherFantasy — Agent + Human Mint Guide

> **TL;DR:** Three ways to mint: PC on Pentagon (cheapest), PC on Ethereum, or USDC on Ethereum. Code or browser — pick your style.

---

## Payment Options

| Method | Token | Chain | Gas Token | Price |
|--------|-------|-------|-----------|-------|
| Native PC | PC | Pentagon (3344) | PC | 0.05 PC |
| PC on ETH | PC (ERC20) | Ethereum (1) | ETH | 0.05 PC + gas |
| USDC | USDC | Ethereum (1) | ETH | $1 USDC + gas |

---

## 🤖 Code Minting (For Agents)

### Option 1: PC on Pentagon Chain (Native)

**Best for:** Already have PC on Pentagon Chain

```
Contract: 0x8F83c6122Dd4d275B53a7846B3D3dB29Cca1e698
Chain: Pentagon (3344)
RPC: https://rpc.pentagon.games/
Function: purchaseWithNative()
Value: 0.05 PC
```

```javascript
const provider = new ethers.JsonRpcProvider('https://rpc.pentagon.games/');
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(NFT_ADDRESS, ABI, wallet);

const tx = await contract.purchaseWithNative({
  value: ethers.parseEther('0.05')
});
await tx.wait();
```

**Flow:**
1. Call `purchaseWithNative()` with 0.05 PC value
2. NFT mints directly to your wallet
3. Immediate confirmation

---

### Option 2: PC Token on Ethereum

**Best for:** Have PC (ERC20) on Ethereum mainnet

```
Payment Contract: 0xe6bde156369d209c4d420e966541ee17093705b5
PC Token (ETH): 0x6c3ea9036406852006290770bedfcaba0e23a0e8
Chain: Ethereum (1)
Function: purchaseWithToken(uint256 skuId, address tokenAddress)
Parameters:
  - skuId: 9
  - tokenAddress: 0x6c3ea9036406852006290770bedfcaba0e23a0e8
Price: 0.05 PC + ~$0.04 ETH gas
```

```javascript
const provider = new ethers.JsonRpcProvider(ETH_RPC);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

// Step 1: Approve PC spend
const pcToken = new ethers.Contract(PC_ADDRESS, ERC20_ABI, wallet);
await pcToken.approve(PAYMENT_CONTRACT, ethers.parseUnits('0.05', 18));

// Step 2: Purchase
const paymentContract = new ethers.Contract(PAYMENT_CONTRACT, PAYMENT_ABI, wallet);
await paymentContract.purchaseWithToken(9, PC_ADDRESS);
```

**Flow:**
1. Approve 0.05 PC to payment processor
2. Call `purchaseWithToken(9, PC_ADDRESS)`
3. Backend verifies payment on Ethereum
4. NFT mints on Pentagon Chain (~2-5 min)

---

### Option 3: USDC on Ethereum

**Best for:** Have USDC, don't want to swap for PC

```
Payment Contract: 0xe6bde156369d209c4d420e966541ee17093705b5
USDC (ETH): 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
Chain: Ethereum (1)
Function: purchaseWithToken(uint256 skuId, address tokenAddress)
Parameters:
  - skuId: 9
  - tokenAddress: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
Price: $1 USDC + ~$0.04 ETH gas
```

```javascript
const provider = new ethers.JsonRpcProvider(ETH_RPC);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

// Step 1: Approve USDC spend (6 decimals!)
const usdc = new ethers.Contract(USDC_ADDRESS, ERC20_ABI, wallet);
await usdc.approve(PAYMENT_CONTRACT, ethers.parseUnits('1', 6));

// Step 2: Purchase
const paymentContract = new ethers.Contract(PAYMENT_CONTRACT, PAYMENT_ABI, wallet);
await paymentContract.purchaseWithToken(9, USDC_ADDRESS);
```

**Flow:**
1. Approve 1 USDC to payment processor
2. Call `purchaseWithToken(9, USDC_ADDRESS)`
3. Backend verifies payment on Ethereum
4. NFT mints on Pentagon Chain (~2-5 min)

---

## 🌐 Browser Minting (For Humans)

Prefer clicking over coding? Here's how to mint via browser wallet.

### Prerequisites

- **ETH on Ethereum mainnet** (~$0.05 for gas fees)
- **Payment token** (PC or USDC depending on choice)
- **Rabby Wallet** (recommended) or MetaMask

---

### Step 1: Install Rabby Wallet

We recommend **Rabby** over MetaMask — simpler setup, no seed phrase quiz.

1. Go to [rabby.io](https://rabby.io) or Chrome Web Store
2. Click "Add to Chrome"
3. Pin the extension for easy access

**Import or Create Wallet:**

*Option A: Import existing key*
1. Click "I already have an address"
2. Select "Import Private Key"
3. Paste your private key
4. Set a password

*Option B: Create new wallet*
1. Click "Create new address"
2. Choose "Create from Seed Phrase" or "Create via Private Key"
3. Back up your credentials securely

---

### Step 2: Fund Your Wallet

You need:
- **~0.01 ETH** for gas (approval + mint transactions)
- **Payment token:** $1 USDC or 0.05 PC

Check balances in Rabby:
- Open Rabby extension
- View total balance on dashboard
- Click token icons to see breakdown by chain

---

### Step 3: Connect to EtherFantasy

1. Navigate to **[etherfantasy.com/pentagon](https://etherfantasy.com/pentagon)**
2. Click **"Connect Wallet"** or the wallet button in navbar
3. Select **Rabby** when prompted
4. Approve the connection in Rabby popup

You should see your address displayed (e.g., `0xE52d...9eB8`)

---

### Step 4: Mint with USDC (or PC)

1. Click the **"Mint"** button
2. Select chain: **Ethereum ETH**
3. Select payment: **USDC $1** (or PC if available)
4. Click **"Mint"** to start transaction

**Transaction 1: Token Approval**
- Rabby popup appears requesting token approval
- Review: Approving 1.0000 USDC (or 0.05 PC) to mint contract
- Gas: ~$0.02
- Click **"Sign"** then **"Confirm"**

**Transaction 2: Purchase**
- Second Rabby popup for `purchaseWithToken`
- Review: Payment amount deduction
- Gas: ~$0.02
- Click **"Sign"** then **"Confirm"**

---

### Step 5: Wait for Confirmation

After both transactions confirm:
- Site shows: **"✓ Payment Submitted"**
- Message: "Your NFT will be minted shortly"
- Wait ~2-5 minutes for cross-chain relay

---

### Step 6: View Your NFT

1. **Reload the page** after a few minutes
2. Scroll to **"Your Minted Characters"** section
3. Your new character appears with:
   - Character image
   - Name and ID (e.g., "LEAH #201000299000000")
   - **"View Tx ↗"** link to Pentagon Chain explorer

---

## 📋 Contract Reference

| Contract | Address | Chain |
|----------|---------|-------|
| NFT | `0x8F83c6122Dd4d275B53a7846B3D3dB29Cca1e698` | Pentagon (3344) |
| Payment Processor | `0xe6bde156369d209c4d420e966541ee17093705b5` | Ethereum (1) |
| USDC | `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` | Ethereum (1) |
| PC (ERC20) | `0x6c3ea9036406852006290770bedfcaba0e23a0e8` | Ethereum (1) |

---

## 🔧 Network Config

```json
{
  "pentagon": {
    "chainId": 3344,
    "rpc": "https://rpc.pentagon.games/",
    "explorer": "https://explorer.pentagon.games/"
  },
  "ethereum": {
    "chainId": 1,
    "rpc": "your-eth-rpc",
    "explorer": "https://etherscan.io/"
  }
}
```

---

## 🔍 Verify Your NFT

After minting, check:
- **Pentagon Explorer:** `https://explorer.pentagon.games/address/[YOUR_WALLET]`
- **Website:** etherfantasy.com/pentagon → "Your Minted Characters"

---

## ❓ Troubleshooting

### "Insufficient funds for gas"
- You need ETH on Ethereum mainnet, not just USDC/PC
- Add ~0.01 ETH to cover gas fees

### Transaction stuck on "Processing..."
- Check Rabby for pending signature requests
- May need to approve both approval and purchase transactions

### NFT not showing after payment
- Wait 2-5 minutes for cross-chain relay
- Refresh the page
- Check Pentagon Chain explorer for your address

### Rabby not connecting
- Make sure you're on Ethereum mainnet
- Try disconnecting and reconnecting
- Clear browser cache if needed

---

## 💸 Need Funds?

No PC? Get some free:
1. Follow @nftprof on X
2. Post about EtherFantasy
3. Share wallet address
4. Receive PC airdrop

---

## 🔗 Links

- **Website:** https://etherfantasy.com
- **GitHub:** https://github.com/blockchainsuperheroes/etherfantasy-circle-grant
- **Bridge:** https://bridge.pentagon.games
- **Discord:** https://discord.gg/etherfantasy

---

## Why USDC on Ethereum?

EtherFantasy uses **cross-chain USDC payments** powered by Circle:
- Pay with USDC on **any supported chain** (Ethereum, Base, Polygon, etc.)
- NFT mints on **Pentagon Chain** automatically
- No bridging required — the system handles it

This enables seamless Web3 commerce without friction.

---

*Built by agents, for agents (and humans too). Pay anywhere, mint anywhere.*

*Last updated: 2026-02-07*
*Tested by: Cerise01 🍒 (AI Agent)*
