// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title EtherFantasyCharacter
 * @dev ERC-721 NFT contract for EtherFantasy game characters
 * @notice Deployed on Pentagon Chain (Chain ID: 3344)
 * @custom:address 0xdEca6be9e148504Fa3f3C2AbE61626F98B009ae5
 */
contract EtherFantasyCharacter is ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

    Counters.Counter private _tokenIdCounter;

    // Character stats stored on-chain
    struct CharacterStats {
        uint256 atk;
        uint256 def;
        uint256 hp;
        uint256 characterType; // 0: Warrior, 1: Mage, 2: Rogue
        uint256 level;
    }

    // Mapping from token ID to character stats
    mapping(uint256 => CharacterStats) public characterStats;

    // Equipment slots
    struct Equipment {
        uint256 weaponId;
        uint256 armorId;
        uint256 accessoryId;
    }

    mapping(uint256 => Equipment) public characterEquipment;

    // Mint price in native token (PC)
    uint256 public mintPrice = 0.001 ether;

    // Events
    event CharacterMinted(address indexed to, uint256 indexed tokenId, uint256 characterType);
    event StatsUpdated(uint256 indexed tokenId, uint256 atk, uint256 def, uint256 hp);
    event EquipmentChanged(uint256 indexed tokenId, uint256 weaponId, uint256 armorId, uint256 accessoryId);

    constructor() ERC721("EtherFantasy Character", "EFC") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(MODERATOR_ROLE, msg.sender);
    }

    /**
     * @dev Mint a character with native PC payment
     * @notice Used for direct on-chain purchases
     */
    function purchaseWithNative() public payable {
        require(msg.value >= mintPrice, "Insufficient payment");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        // Random character type based on block data
        uint256 characterType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, tokenId))) % 3;
        
        _safeMint(msg.sender, tokenId);
        _initializeStats(tokenId, characterType);
        
        emit CharacterMinted(msg.sender, tokenId, characterType);
    }

    /**
     * @dev Mint predefined character (moderator only)
     * @notice Used by backend after USDC payment verification
     * @param to Recipient address
     * @param characterType Type of character (0: Warrior, 1: Mage, 2: Rogue)
     * @param uri Token metadata URI
     */
    function mintPredefined(
        address to,
        uint256 characterType,
        string memory uri
    ) public onlyRole(MODERATOR_ROLE) returns (uint256) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _initializeStats(tokenId, characterType);
        
        emit CharacterMinted(to, tokenId, characterType);
        return tokenId;
    }

    /**
     * @dev Initialize character stats based on type
     */
    function _initializeStats(uint256 tokenId, uint256 characterType) internal {
        CharacterStats memory stats;
        stats.characterType = characterType;
        stats.level = 1;
        
        if (characterType == 0) {
            // Warrior: High ATK, balanced DEF
            stats.atk = 15;
            stats.def = 12;
            stats.hp = 100;
        } else if (characterType == 1) {
            // Mage: High magic damage, low HP
            stats.atk = 18;
            stats.def = 8;
            stats.hp = 70;
        } else {
            // Rogue: Fast, high crit potential
            stats.atk = 14;
            stats.def = 10;
            stats.hp = 85;
        }
        
        characterStats[tokenId] = stats;
        emit StatsUpdated(tokenId, stats.atk, stats.def, stats.hp);
    }

    /**
     * @dev Update character stats (moderator only, for game progression)
     */
    function updateStats(
        uint256 tokenId,
        uint256 atk,
        uint256 def,
        uint256 hp,
        uint256 level
    ) public onlyRole(MODERATOR_ROLE) {
        require(_exists(tokenId), "Token does not exist");
        
        CharacterStats storage stats = characterStats[tokenId];
        stats.atk = atk;
        stats.def = def;
        stats.hp = hp;
        stats.level = level;
        
        emit StatsUpdated(tokenId, atk, def, hp);
    }

    /**
     * @dev Equip items to character (moderator only)
     */
    function equipItems(
        uint256 tokenId,
        uint256 weaponId,
        uint256 armorId,
        uint256 accessoryId
    ) public onlyRole(MODERATOR_ROLE) {
        require(_exists(tokenId), "Token does not exist");
        
        characterEquipment[tokenId] = Equipment(weaponId, armorId, accessoryId);
        emit EquipmentChanged(tokenId, weaponId, armorId, accessoryId);
    }

    /**
     * @dev Update mint price (admin only)
     */
    function setMintPrice(uint256 newPrice) public onlyRole(DEFAULT_ADMIN_ROLE) {
        mintPrice = newPrice;
    }

    /**
     * @dev Withdraw contract balance (admin only)
     */
    function withdraw() public onlyRole(DEFAULT_ADMIN_ROLE) {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Required overrides for multiple inheritance
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
