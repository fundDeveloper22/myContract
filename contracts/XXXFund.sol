// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

import './interfaces/IXXXFund.sol';
import './interfaces/IERC20Minimal.sol';
import './interfaces/IXXXFactory.sol';

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

contract XXXFund is IXXXFund {

    // Uniswap v3 swapRouter
    address swapRouterAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    uint256 SHARE_DECIMAL = 10 ** 6; 

    struct Token {
        address tokenAddress;
        uint256 amount;
    }

    struct InvestorHistory {
        string date;
        string history;
    }

    address public factory;
    address public manager;

    //fund info
    uint256 fundPrincipalUSD = 0;
    mapping(uint265 => Token) public fundTokens;
    uint256 public fundTokenCount = 0;
    //investor info
    mapping(address => uint265) public investorPrincipalUSD;
    mapping(address => mapping(uint265 => Token)) public investorTokens;
    mapping(address => uint265) public investorTokenCount;
    mapping(address => mapping(uint265 => InvestorHistory)) public investorHistory;
    mapping(address => uint265) public investorHistoryCount;


    ISwapRouter public immutable swapRouter;


    event Deposit(address indexed sender, address _token, uint256 _amount);
    event Withdraw(address indexed sender, address _token, uint256 _amount);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );


    uint256 private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'XXXFund: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    // Modifier to check that the caller is the manager of
    // the contract.
    modifier onlyManager() {
        require(msg.sender == manager, "Not manager");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }


    constructor() {
        factory = msg.sender;
        swapRouter = ISwapRouter(swapRouterAddress);
    }
    
    function getPriceUSD(address token) private returns (uint256 fiatPrice) {
        fiatPrice = 0; 
    }

    function getFundTotalValueUSD() private returns (uint256 totalFiatValue) {
        totalFiatValue = 0;
        // for (uint256 i = 0; i < tokens.length; i++) {
        //     address token = tokens[i];
        //     uint256 tokenFiatPrice = getPriceUSD(token);
        //     uint256 tokenAmount = tokenAmount[token];
        //     require(tokenFiatPrice >= 0);
        //     totalFiatValue += tokenFiatPrice * tokenAmount;
        // }
    }

    function getInvestorTotalValueUSD(address investor) private returns (uint256 totalFiatValue) {
        totalFiatValue = 0;
        // for (uint256 i = 0; i < tokens.length; i++) {
        //     address token = tokens[i];
        //     uint256 tokenFiatPrice = getPriceUSD(token);
        //     uint256 tokenAmount = tokenAmount[token];
        //     require(tokenFiatPrice >= 0);
        //     totalFiatValue += tokenFiatPrice * tokenAmount;
        // }
    }

    function setInvestorHistory(address token) private returns (uint256 fiatPrice) {
        InvestorHistory memory _investorHistory;
        _investorHistory.
        investorHistory.push();



    }


    // called once by the factory at time of deployment
    function initialize(address _manager, address _token, uint256 _amount) override external {
        require(msg.sender == factory, 'XXXFund: FORBIDDEN'); // sufficient check
        manager = _manager;

        if (_token != address(0) && _amount > 0) {
            Token memory token;
            token.tokenAddress = _token;
            token.amount = _amount;
            string _date = getDate();
            uint265 depositValue = getPriceUSD(_token) * _amount;

            investorTokens[_manager][0] = token;
            investorHistory[_manager][0].date = _date;
            investorHistory[_manager][0].history = _history;
            investorHistoryCount[_manager] += 1;
            investorPrincipalUSD[_manager] += depositValue;

            fundTokens[fundTokenCount] = token;
            fundTokenCount += 1;
            fundPrincipalUSD += depositValue;

            emit Deposit(manager, _token, _amount);
        }
    }

    function getFiatAmount(address token, uint256 _amount) private returns (uint256 fiatAmount) {
        fiatAmount = 0; 
    }

    function getTotalFiatAmount() private returns (uint256 totalFiatAmount) {
        totalFiatAmount = 0; 
    }

    function increaseTokenAmount(Token[] memory _tokens, uint256 _tokenCount, address _token, uint256 _amount) returns (bool isNewToken){
        bool isNewToken = true;
        for (uint256 i=0; i<_tokenCount; i++) {
            if (_tokens[i].tokenAddress == _token) {
                isNewToken = false;
                _tokens[i].amount += _amount;
                break;
            }
        }
    }

    function decreaseTokenAmount(Token[] memory _tokens, uint256 _tokenCount, uint256 _amount) returns (bool isNewToken){
        bool isNewToken = true;
        for (uint256 i=0; i<_tokenCount; i++) {
            if (_tokens[i].tokenAddress == _token) {
                isNewToken = false;
                require(_tokens[i].amount >= _amount, 'decreaseTokenAmount: decrease token amount is more than you have');
                _tokens[i].amount -= _amount;
                break;
            }
        }
    }

    function updateInvestorHistory(address investor, string _history) {
        uint256 newHistoryIndex = investorHistoryCount[investor];
        investorHistory[investor][newHistoryIndex].date = getDate();
        investorHistory[investor][newHistoryIndex].history = _history;
        investorHistoryCount[investor] += 1;
    }

    function updateDepositInfo(address investor, address _token, uint256 _amount) {
        //update fund info
        bool isNewFundToken = increaseTokenAmount(fundTokens, fundTokenCount, _token, _amount);
        if (isNewFundToken) {
            fundTokens[fundTokenCount].tokenAddress = _token;
            fundTokens[fundTokenCount].amount = _amount;
            fundTokenCount += 1;
        }
        uint256 depositValue = getPriceUSD(_token) * _amount;
        string _history = '';
        fundPrincipalUSD += depositValue;

        //update investor info
        bool isNewInvestorToken = increaseTokenAmount(investorTokens[investor], investorTokenCount[investor], _token, _amount);
        if (isNewInvestorToken) {
            uint256 newTokenIndex = investorTokenCount[investor];
            investorTokens[investor][newTokenIndex].tokenAddress = _token;
            investorTokens[investor][newTokenIndex].amount = _amount;
            investorTokenCount[investor] += 1;
        }
        updateInvestorHistory(investor, _history);
        investorPrincipalUSD[investor] += depositValue;
    }

    function updateWithdrawInfo(address investor, address _token, uint256 _amount) {
        //update fund info
        bool isNewFundToken = decreaseTokenAmount(fundTokens, fundTokenCount, _token, _amount);
        require(isNewFundToken == false, 'updateWithdrawInfo: Invalid fund token withdraw attempt');
        uint256 withdrawValue = getPriceUSD(_token) * _amount;
        string _history = '';
        uint256 fundWithdrawRatio = withdrawValue / getFundTotalValueUSD();
        fundPrincipalUSD -= fundPrincipalUSD * fundWithdrawRatio;

        //update investor info
        bool isNewInvestorToken = decreaseTokenAmount(investorTokens[investor], investorTokenCount[investor], _token, _amount);
        require(isNewInvestorToken == false, 'updateWithdrawInfo: Invalid investor token withdraw attempt');
        updateInvestorHistory(investor, _history);
        uint256 investorWithdrawRatio = withdrawValue / getInvestorTotalValueUSD();
        investorPrincipalUSD[investor] -= investorPrincipalUSD[investor] * investorWithdrawRatio;
    }

    function updateSwapInfo(address investor, address swapFrom, address swapTo, uint256 swapFromAmount, uint256 swapToAmount) onlyManager {
        //update fund info
        //decrease part of swap (decrease swapFrom token reduce by swapFromAmount)
        bool isNewFundToken = decreaseTokenAmount(fundTokens, fundTokenCount, swapFrom, swapFromAmount);
        require(isNewFundToken == false, 'updateSwapInfo: Invalid fund token swap attempt');
        //increase part of swap (increase swapTo token increase by swapToAmount)
        isNewFundToken = increaseTokenAmount(fundTokens, fundTokenCount, swapTo, swapToAmount);
        if (isNewFundToken) {
            fundTokens[fundTokenCount].tokenAddress = swapTo;
            fundTokens[fundTokenCount].amount = swapToAmount;
            fundTokenCount += 1;
        }

        //update investor info
        //decrease part of swap (decrease swapFrom token reduce by swapFromAmount)
        bool isNewInvestorToken = decreaseTokenAmount(investorTokens[investor], investorTokenCount[investor], swapFrom, swapFromAmount);
        require(isNewInvestorToken == false, 'updateSwapInfo: Invalid investor token withdraw attempt');
        //increase part of swap (increase swapTo token increase by swapToAmount)
        isNewInvestorToken = increaseTokenAmount(investorTokens[investor], investorTokenCount[investor], swapTo, swapToAmount);
        if (isNewInvestorToken) {
            uint256 newTokenIndex = investorTokenCount[investor];
            investorTokens[investor][newTokenIndex].tokenAddress = swapTo;
            investorTokens[investor][newTokenIndex].amount = swapToAmount;
            investorTokenCount[investor] += 1;
        }
        string _history = '';
        updateInvestorHistory(investor, _history);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function deposit(address investor, address _token, uint256 _amount) override external lock {
        require(msg.sender == investor); // sufficient check

        TransferHelper.safeTransfer(_token, address(this), _amount);

        updateDepositInfo(address investor, address _token, uint256 _amount);

        emit Deposit(investor, _token, _amount);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function withdraw(address investor, address _token, uint256 _amount) override external lock {
        require(msg.sender == investor); // sufficient check

        //todo add transfer function ex)TransferHelper.safeTransfer(_token, address(this), _amount);

        updateWithdrawInfo(address investor, address _token, uint256 _amount);

        emit Withdraw(investor, _token, _amount);
    }

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;


    function swapExactInputSingle(ISwapRouter.ExactInputSingleParams calldata _params) onlyManager external returns (uint256 amountOut) {
        // msg.sender must approve this contract

        // Transfer the specified amount of DAI to this contract.
        TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), _params.amountIn);

        // Approve the router to spend DAI.
        TransferHelper.safeApprove(DAI, address(swapRouter), _params.amountIn);

        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: _params.tokenIn,
                tokenOut: _params.tokenOut,
                fee: _params.fee,
                recipient: address(this),
                deadline: _params.deadline,
                amountIn: _params.amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);

        updateSwapInfo();
    }

    function swapExactOutputSingle(ISwapRouter.ExactOutputSingleParams calldata _params) onlyManager external returns (uint256 amountIn) {
        // Transfer the specified amount of DAI to this contract.
        TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), _params.amountInMaximum);

        // Approve the router to spend the specifed `amountInMaximum` of DAI.
        // In production, you should choose the maximum amount to spend based on oracles or other data sources to acheive a better swap.
        TransferHelper.safeApprove(DAI, address(swapRouter), _params.amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: _params.tokenIn,
                tokenOut: _params.tokenOut,
                fee: _params.fee,
                recipient: address(this),
                deadline: _params.deadline,
                amountOut: _params.amountOut,
                amountInMaximum: _params.amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
        amountIn = swapRouter.exactOutputSingle(params);

        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < _params.amountInMaximum) {
            TransferHelper.safeApprove(DAI, address(swapRouter), 0);
            TransferHelper.safeTransfer(DAI, msg.sender, _params.amountInMaximum - amountIn);
        }

        updateSwapInfo();
    }

    function swapExactInputMultihop(ISwapRouter.ExactInputParams calldata _params) onlyManager external returns (uint256 amountOut) {
        // Transfer `amountIn` of DAI to this contract.
        TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), _params.amountIn);

        // Approve the router to spend DAI.
        TransferHelper.safeApprove(DAI, address(swapRouter), _params.amountIn);

        // Multiple pool swaps are encoded through bytes called a `path`. A path is a sequence of token addresses and poolFees that define the pools used in the swaps.
        // The format for pool encoding is (tokenIn, fee, tokenOut/tokenIn, fee, tokenOut) where tokenIn/tokenOut parameter is the shared token across the pools.
        // Since we are swapping DAI to USDC and then USDC to WETH9 the path encoding is (DAI, 0.3%, USDC, 0.3%, WETH9).
        ISwapRouter.ExactInputParams memory params =
            ISwapRouter.ExactInputParams({
                path: _params.path, //abi.encodePacked(DAI, poolFee, USDC, poolFee, WETH9),
                recipient: address(this),
                deadline: _params.deadline,
                amountIn: _params.amountIn,
                amountOutMinimum: 0
            });

        // Executes the swap.
        amountOut = swapRouter.exactInput(params);

        updateSwapInfo();
    }

    function swapExactOutputMultihop(ISwapRouter.ExactOutputParams calldata _params) onlyManager external returns (uint256 amountIn) {
        // Transfer the specified `amountInMaximum` to this contract.
        TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), _params.amountInMaximum);
        // Approve the router to spend  `amountInMaximum`.
        TransferHelper.safeApprove(DAI, address(swapRouter), _params.amountInMaximum);

        // The parameter path is encoded as (tokenOut, fee, tokenIn/tokenOut, fee, tokenIn)
        // The tokenIn/tokenOut field is the shared token between the two pools used in the multiple pool swap. In this case USDC is the "shared" token.
        // For an exactOutput swap, the first swap that occurs is the swap which returns the eventual desired token.
        // In this case, our desired output token is WETH9 so that swap happpens first, and is encoded in the path accordingly.
        ISwapRouter.ExactOutputParams memory params =
            ISwapRouter.ExactOutputParams({
                path: _params.path, //abi.encodePacked(WETH9, poolFee, USDC, poolFee, DAI),
                recipient: address(this),
                deadline: block.timestamp,
                amountOut: _params.amountOut,
                amountInMaximum: _params.amountInMaximum
            });

        // Executes the swap, returning the amountIn actually spent.
        amountIn = swapRouter.exactOutput(params);

        // If the swap did not require the full amountInMaximum to achieve the exact amountOut then we refund msg.sender and approve the router to spend 0.
        if (amountIn < _params.amountInMaximum) {
            TransferHelper.safeApprove(DAI, address(swapRouter), 0);
            TransferHelper.safeTransferFrom(DAI, address(this), msg.sender, _params.amountInMaximum - amountIn);
        }

        updateSwapInfo();
    }
}