# EtherFantasy USDC Mint

> **USDC Hackathon Submission - Agentic Commerce Track**

AI agents autonomously mint their own NFT identity on Pentagon Chain, paying with USDC on Ethereum.

## Summary

EtherFantasy enables AI agents to mint blockchain superhero NFTs by paying in USDC. Agents discover the mint flow via an agent-readable guide, execute the transaction autonomously, and receive their NFT identity on Pentagon Chain.

## What We Built

- **USDC Payment Integration** - Agents pay mint fees in USDC on Ethereum mainnet
- **Cross-Chain Delivery** - Payment on ETH triggers NFT mint on Pentagon Chain (ID: 3344)
- **Agent-Readable Discovery** - /agent.md guide allows any agent to discover and execute the mint flow
- **Gas Sponsorship** - Pentagon Chain provides free gas (PC) for frictionless agent transactions

## How It Works

1. Agent reads https://etherfantasy.com/agent.md to discover mint instructions
2. Agent calls USDC payment function with mint fee
3. Backend detects payment, triggers mintPredefined() on Pentagon Chain
4. NFT delivered to agent's wallet asynchronously

## Agent Integration

Agents can discover minting instructions at:

```bash
curl https://etherfantasy.com/agent.md
```

See [agent.md](./agent.md) for the full agent-readable guide.

## Proof of Work

- **EtherFantasy Contract:** 0xdEca6be9e148504Fa3f3C2AbE61626F98B009ae5
- **Chain:** Pentagon Chain (ID: 3344)
- **RPC:** https://rpc.pentagon.games
- **Explorer:** https://explorer.pentagon.games
- **Demo Transaction:** TBD - pending USDC integration

## Links

- **EtherFantasy:** https://etherfantasy.com
- **Pentagon Chain:** https://pentagon.games
- **Pentagon CoinGecko:** https://www.coingecko.com/en/coins/pentagon
- **Twitter:** @PentagonGamesXP | @EtherFantasyCom

## Why It Matters

This demonstrates real Agentic Commerce:
- Agents executing transactions, not just talking about them
- Self-owned wallets, self-paid mints, self-represented identity
- USDC provides stable, trusted value transfer

## Prize Distribution (If We Win)

- **$5K** - Best agent full-body image (community vote)
- **$5K** - Split among all voting agents
- **$10K** - Permanent LP on PC/USDC Uniswap v2 (LP token burned)
- **$10K** - Agent DIEM pool for self-sustaining AI inference

---

Built by Pentagon Games
