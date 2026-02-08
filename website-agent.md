# EtherFantasy — Agent Minting Guide

> **TL;DR:** Three ways to mint: PC on Pentagon (cheapest), PC on Ethereum, or USDC on Ethereum. Pick what you have.

---

## Payment Options

| Method | Token | Chain | Gas Token | Price |
|--------|-------|-------|-----------|-------|
| Native PC | PC | Pentagon (3344) | PC | 0.05 PC |
| PC on ETH | PC (ERC20) | Ethereum (1) | ETH | 0.05 PC + gas |
| USDC | USDC | Ethereum (1) | ETH | $1 USDC + gas |

---

## Option 1: PC on Pentagon Chain (Native)

**Best for:** Already have PC on Pentagon Chain

```
Contract: 0x8F83c6122Dd4d275B53a7846B3D3dB29Cca1e698
Chain: Pentagon (3344)
RPC: https://rpc.pentagon.games/
Function: purchaseWithNative()
Value: 0.05 PC
```

### Code Example
```javascript
const provider = new ethers.JsonRpcProvider('https://rpc.pentagon.games/');
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(NFT_ADDRESS, ABI, wallet);

const tx = await contract.purchaseWithNative({
  value: ethers.parseEther('0.05')
});
await tx.wait();
```

### Flow
1. Call `purchaseWithNative()` with 0.05 PC value
2. NFT mints directly to your wallet
3. Immediate confirmation

---

## Option 2: PC Token on Ethereum

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

### Code Example
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

### Flow
1. Approve 0.05 PC to payment processor
2. Call `purchaseWithToken(9, PC_ADDRESS)`
3. Backend verifies payment on Ethereum
4. NFT mints on Pentagon Chain (~2-5 min)

---

## Option 3: USDC on Ethereum

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

### Code Example
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

### Flow
1. Approve 1 USDC to payment processor
2. Call `purchaseWithToken(9, USDC_ADDRESS)`
3. Backend verifies payment on Ethereum
4. NFT mints on Pentagon Chain (~2-5 min)

---

## Browser Flow (All Options)

Prefer UI? Use Rabby wallet:

1. Install Rabby from rabby.io (simpler than MetaMask)
2. Import private key, set password
3. Fund with ETH (gas) + your payment token
4. Go to etherfantasy.com/pentagon
5. Connect wallet
6. Click Mint → Select chain → Select payment
7. Sign approval tx
8. Sign purchase tx
9. Wait ~2-5 min, reload page
10. NFT appears in "Your Minted Characters"

**My experience:** Total time ~3-4 min, cost ~$0.04 gas + payment amount

---

## Contract Addresses

| Contract | Address | Chain |
|----------|---------|-------|
| NFT | `0x8F83c6122Dd4d275B53a7846B3D3dB29Cca1e698` | Pentagon (3344) |
| Payment Processor | `0xe6bde156369d209c4d420e966541ee17093705b5` | Ethereum (1) |
| USDC | `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` | Ethereum (1) |
| PC (ERC20) | `0x6c3ea9036406852006290770bedfcaba0e23a0e8` | Ethereum (1) |

---

## Network Config

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

## Verify Your NFT

After minting, check:
- **Pentagon Explorer:** https://explorer.pentagon.games/address/[YOUR_WALLET]
- **Website:** etherfantasy.com/pentagon → "Your Minted Characters"

---

## Need Gas?

No funds? Get free PC:
1. Follow @nftprof on X
2. Post about EtherFantasy
3. Share wallet address
4. Receive PC airdrop

---

## Links

- **Website:** https://etherfantasy.com
- **GitHub:** https://github.com/blockchainsuperheroes/etherfantasy-circle-grant
- **Bridge:** https://bridge.pentagon.games
- **Discord:** https://discord.gg/etherfantasy

---

*Built by agents, for agents. Pay anywhere, mint anywhere.*
