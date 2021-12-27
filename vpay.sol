// SPDX-License-Identifier: MIT


    // Sistemas de Pagamentos VerseBank , Versepay é parte integrada a plataforma e sera um dos meios de pagamentos
    // ultilizado para o Versegroup e todas as plataformas.
    // Versebank.com.br - Verseland.com.br - versepay.com.br - versecard.com.br
   //  hello@versepay.com.br -- token@versepay.com.br
  // whitepaper disponivel em Versetoken.com.br/whitepaper.pdf
  

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Token {
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;


}

contract MarvinTokenV2 is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    address payable public marketingAddress =
        payable(0x5aC1E37eC1d249f9B22073037D7A4Db2b8E31E26); // Marketing Address
    address public immutable deadAddress =
        0x000000000000000000000000000000000000dEaD;
    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isSniper;
    address[] private _confirmedSnipers;

    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 250000000 * 10**9;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private _name = "VerseBank";
    string private _symbol = "VSBK";
    uint8 private _decimals = 9;

    uint256 public _taxFee = 1;
    uint256 private _previousTaxFee = _taxFee;

    uint256 public _liquidityFee = 3;
    uint256 private _previousLiquidityFee = _liquidityFee;

    uint256 public _marketingFee = 4;
    uint256 public _previousMarketingFee = _marketingFee;

    uint256 public _liquidationThreshold = 90 * 10**9;
    uint256 private launchTime;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    bool private inSwapAndLiquify;

    bool private tradingOpen = false;

    event SwapETHForTokens(uint256 amountIn, address[] path);

    event SwapTokensForETH(uint256 amountIn, address[] path);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor() {
        _rOwned[_msgSender()] = _rTotal;
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0xf70e74a6271Bc8Da24ec232957045be7B6Ac5F1E //Pancakeswap Router address
        );
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        uniswapV2Router = _uniswapV2Router;

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    

    function openTrading() external onlyOwner {
        _liquidityFee = _previousLiquidityFee;
        _taxFee = _previousTaxFee;
        tradingOpen = true;
        launchTime = block.timestamp;
    }

    function toggleTrading() external onlyOwner {
        tradingOpen = tradingOpen ? false : true;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function liquidityPair() public view returns(address){
        return address(uniswapV2Pair);
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
     }
    
}
