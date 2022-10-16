// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;
pragma abicoder v2;

abstract contract Constants {

    // Uniswap v3 swapRouter
    address swapRouterAddress = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;

    address UNISWAP_V3_FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984;

    //address WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    //goerli
    address WETH9 = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    address WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599; //WBTC
    //address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; //USDC mainnet
    address USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F; //USDC goerli
    address DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F; //DAI
    address UNI = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984; //UNI
    address XXX = 0xEAE906dC299ccd9Cd94584377d0F96Ce144c942f; //XXX
}