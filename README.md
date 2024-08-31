# Staking-Contract

Staking contracts allows users to stake tokens for a specific duration and earn rewards based on their staking period.

Your task in this problem is to build a staking contract that allows users to deposit ERC-20 tokens and receive rewards on the basis of the time they’ve staked their tokens for.

The calculation of the rewards is done in the following manner:
If less than 1 day has been passed, the user earns no rewards.
If more than 1 day has been passed, the user earns 1% on their staked token amount.
If more than a week has passed, the user earns 10%.
If more than a month (30 days) has been passed, the user earns 50%.
(For example, If Bob and Alice both have deposited 100 TOKENs, if after 2 weeks Bob claims his rewards, he will get 10%, i.e., 10 TOKENs. If Alice claims her rewards after 3 months, she’ll receive 50%, i.e., 50 TOKENs.)

If a user redeems their TOKENs before claiming interest, no interest shall be paid.

Your contract must implement the following public functions / constructor:
 

Input:
constructor(address token) : The constructor sets the token address.

stake(uint256 amount) : This function allows users to stake their tokens. If a user already has a staked balance, the function transfers the accumulated rewards and the staked tokens to the user before adding the new deposit. Otherwise, it adds the new deposit. If amount is 0, the function must revert.

redeem(uint256 amount) : This function allows stakers to redeem their staked tokens. The function must revert if amount is more than currently staked or 0.

claimInterest() : This function transfers the rewards to the staker. The function must revert if no interest is due.

sweep() : This function allows the owner to withdraw all staked tokens
