module addr ::RateLimiting {
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    use std::error;

    const E_RATE_LIMIT_EXCEEDED: u64 = 1;
    const E_RATE_LIMITER_NOT_FOUND: u64 = 2;

    struct RateLimiter has store, key {
        max_transactions: u64,     
        time_window: u64,          
        transaction_count: u64,     
        window_start: u64,          
    }

    public fun initialize_rate_limiter(
        account: &signer, 
        max_transactions: u64, 
        time_window: u64
    ) {
        let current_time = timestamp::now_seconds();
        let rate_limiter = RateLimiter {
            max_transactions,
            time_window,
            transaction_count: 0,
            window_start: current_time,
        };
        move_to(account, rate_limiter);
    }

    public fun check_and_update_rate_limit(account_addr: address) acquires RateLimiter {
        assert!(exists<RateLimiter>(account_addr), error::not_found(E_RATE_LIMITER_NOT_FOUND));
        
        let rate_limiter = borrow_global_mut<RateLimiter>(account_addr);
        let current_time = timestamp::now_seconds();
        
        if (current_time >= rate_limiter.window_start + rate_limiter.time_window) {
            rate_limiter.window_start = current_time;
            rate_limiter.transaction_count = 0;
        };
            assert!(
            rate_limiter.transaction_count < rate_limiter.max_transactions,
            error::permission_denied(E_RATE_LIMIT_EXCEEDED)
        );
        
        rate_limiter.transaction_count = rate_limiter.transaction_count + 1;
    }
}
