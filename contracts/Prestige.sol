// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact 0xcozart@gmail.com
contract MyToken is
    ERC721,
    ERC721URIStorage,
    Pausable,
    Ownable,
    ERC721Burnable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    string private _mintHash;
    string private _prefixUri;

    event Promoted(address indexed _promoted, uint256 indexed _tokenId);

    constructor(string mintHash) ERC721("MyToken", "MTK") {
        _mintHash = mintHash;
        _prefixUri = "https://place.holder";
    }

    struct TokenData {
        uint16 rank;
    }

    mapping(address => TokenData) public ownerToTokenData;

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function totalSupply() public constant returns (uint256) {
        return ownerToTokenData.length;
    }

    function promoteChancellor(address _to) public onlyOwner {}

    function safeMint(
        address _to,
        uint256 _tokenId,
        string memory _uri,
        string _mintKey
    ) public onlyOwner {
        require(!_ownerToToken[to], "address already has a token");
        require(_mintHash == keccak256(_mintKey), "invalid mint key");
        uint256 tokenId = _tokenIdCounter.current();
        totalSupply.increment();
        _tokenIdCounter.increment();
        _safeMint(to, _tokenId);
        _setTokenURI(tokenId, _prefixUri + _uri);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
